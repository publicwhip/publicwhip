#!/usr/bin/php -q
<?php

require_once __DIR__.'/../website/config.php';
require_once __DIR__.'/../website/db.inc';
require_once __DIR__.'/../website/wiki.inc';
require_once __DIR__.'/popolo.inc';


# generate policies - 1 file per policy
# generate motions - 1 file per policy?
#

function get_motions_for_policy($policy_id) {
    global $pwpdo;
    $pw_motions = array();

    $motions = $pwpdo->fetch_all_rows(
        "SELECT pw_div.division_id, pw_div.division_date, pw_div.division_number, dv.vote, pw_div.division_name, dv.house, div_info.aye_majority, source_url, source_gid
        FROM pw_dyn_dreamvote AS dv
        LEFT JOIN pw_division AS pw_div USING (division_date, division_number, house)
        LEFT JOIN pw_cache_divinfo AS div_info USING (division_id)
        WHERE dream_id = ?",
        array($policy_id));

    foreach ($motions as $motion) {
        $details = array();
        $details['source'] = sprintf(
            'http://www.publicwhip.org.uk/division.php?date=%s&number=%s&dmp=%s&house=%s&display=allpossible',
            $motion['division_date'],
            $motion['division_number'],
            $policy_id,
            $motion['house']
        );

        if ($motion['aye_majority'] && ($motion['vote'] == "aye" || $motion['vote'] == "aye3" || $motion['vote'] == "no" || $motion['vote'] == "no3" || $motion['vote'] == "both")) {
	    if ( $motion['vote'] == 'both' ) {
		$direction = "abstention";
            } else if (($motion['aye_majority'] >= 0) || ($motion['vote'] == "aye" || $motion['vote'] == "aye3")) {
                $direction = "Majority";
            } else {
                $direction = "minority";
            }

            if ($motion['vote'] == "aye3" || $motion['vote'] == "no3") {
                $direction .= " (strong)";
            }

            $details['direction'] = $direction;
        }

        // if there's no direction then it means it's not relevant for policy direction
        if ( !isset($details['direction']) ) {
            printf("skipping pw-%s-%s-%s as no direction\n", $motion['division_date'], $motion['division_number'], $motion['house']);
            continue;
        }


        $motion_data = get_wiki_current_value("motion", array($motion["division_date"], $motion["division_number"], $motion['house']));
        $actions = extract_action_text_from_wiki_text($motion_data['text_body']);

        $pw_motion = array();
        $pw_motion['id'] = sprintf("pw-%s-%s-%s", $motion['division_date'], $motion['division_number'], $motion['house']);
        $pw_motion['organization_id'] = 'uk.parliament.' . $motion['house'];
        $pw_motion['text'] = utf8_encode(htmlentities($actions['title'], null, 'UTF-8', false));
        if ( array_key_exists('aye', $actions) && array_key_exists('no', $actions) ) {
            $pw_motion['actions'] = array(
                'yes' => utf8_encode(htmlentities($actions['aye'], null, 'UTF-8', false)),
                'no' => utf8_encode(htmlentities($actions['no'], null, 'UTF-8', false))
            );
        }
        $pw_motion['policy_vote'] = $motion['vote'];
        $pw_motion['date'] = $motion['division_date'];
        $pw_motion['vote_events'] = array( get_division_votes($motion['division_id'], $motion['house'], $motion['division_date']) );
        $pw_motion['sources'] = array(
            array( 'url' => sprintf( 'http://www.publicwhip.org.uk/division.php?date=%s&number=%s&display=allpossible',
                $motion['division_date'],
                $motion['division_number'])
            ),
            array( 'url' => $motion['source_url'] ),
            array( 'gid' => $motion['source_gid'] )
        );

        $details['motion'] = $pw_motion;

        $pw_motions[] = $details;
    }

    return $pw_motions;
}

$policies = $pwpdo->fetch_all_rows("SELECT dream_id, name, description FROM pw_dyn_dreammp where private = 0 OR dream_id in (1087, 6718, 6719)", array());

$all_policies = array();

$motion_count = 0;
$policy_count = 0;
$vote_count = 0;
foreach ($policies as $policy) {
    $details = array();
    $details['title'] = utf8_encode($policy['name']);
    $details['text'] = utf8_encode(htmlentities($policy['description'], null, null, false));
    $details['sources'] = array( "url" => "http://www.publicwhip.org.uk/policy.php?id=" . $policy['dream_id'] );
    $details['aspects'] = get_motions_for_policy($policy['dream_id']);

    if ( count( $details['aspects'] ) > 0 ) {
        $policy_count++;
        $motion_count += count($details['aspects']);
        save_to_json_file($details, $policy['dream_id'] . '.json');
        $all_policies[] = $details;
    }
}

print "generated json for $policy_count policies containing $motion_count motions and $vote_count votes\n";

save_to_json_file($all_policies, 'policies.json');
