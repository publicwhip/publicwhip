#!/usr/bin/php -q
<?php

require_once __DIR__.'/../website/config.php';
require_once __DIR__.'/../website/db.inc';
require_once __DIR__.'/../website/wiki.inc';
require_once __DIR__.'/popolo.inc';

function get_motions() {
    global $pwpdo;
    $pw_motions = array();

    $date = date('Y-m-d', time() - 86400 * 28);
    $query = 'SELECT text_body, division_date, division_number, house, division_name, division_id, source_url, source_gid
    FROM pw_dyn_wiki_motion pw
        JOIN pw_division USING (division_date,division_number,house)
    WHERE
        wiki_id IN (SELECT MAX(wiki_id) FROM pw_dyn_wiki_motion AS pw2
                    WHERE pw2.division_date=pw.division_date AND pw2.division_number=pw.division_number AND pw2.house=pw.house)
        AND edit_date > ?
    ORDER BY wiki_id DESC';
    $allRows = $pwpdo->fetch_all_rows($query, array($date));
    foreach ($allRows as $motion) {
        $motion['text_body'] = add_motion_missing_wrappers($motion['text_body'], $motion['division_name']);
        $actions = extract_action_text_from_wiki_text($motion['text_body']);

        $pw_motion = array(
            'id' => sprintf("pw-%s-%s-%s", $motion['division_date'], $motion['division_number'], $motion['house']),
            'organization_id' => 'uk.parliament.' . $motion['house'],
            'text' => $actions['title'],
            'date' => $motion['division_date'],
            'vote_events' => array(get_division_votes($motion['division_id'], $motion['house'], $motion['division_date'])),
        );
        if (array_key_exists('aye', $actions) && array_key_exists('no', $actions)) {
            $pw_motion['actions'] = array(
                'yes' => $actions['aye'],
                'no' => $actions['no'],
            );
        }

        $url = sprintf('https://www.publicwhip.org.uk/division.php?date=%s&number=%s&house=%s&display=allpossible',
            $motion['division_date'], $motion['division_number'], $motion['house']);
        $pw_motion['sources'] = array(
            array('url' => $url),
            array('url' => $motion['source_url']),
            array('gid' => $motion['source_gid']),
        );

        $details = array('motion' => $pw_motion);
        $pw_motions[] = $details;
    }

    return $pw_motions;
}

$vote_count = 0;
$details = array(
    'title' => 'Recently updated divisions',
    'text' => 'Recently updated divisions',
    'sources' => array(
        "url" => "https://www.publicwhip.org.uk/divisions.php"
    ),
    'aspects' => get_motions(),
);

if (count($details['aspects']) > 0) {
    $motion_count = count($details['aspects']);
    print "generated json for $motion_count motions and $vote_count votes\n";
    save_to_json_file($details, 'recently-changed-divisions.json');
}
