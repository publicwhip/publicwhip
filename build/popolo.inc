<?php

$data_dir = __DIR__ . '/../website/data/';
if (!file_exists($data_dir) && !is_dir($data_dir)) {
    print "Can't find website data directory: $data_dir\n";
    exit();
}

$output_dir = $data_dir . 'popolo/';
if (!file_exists($output_dir)) {
    mkdir($output_dir);
}

function fix_counts($vote, $value) {
    return array(
        "option" => $vote,
        "value" => $value
    );
}

function get_division_votes($division_id, $house, $date) {
    global $pwpdo, $vote_count;

    /*
     * Because we want to count absents we need to grab all the members that
     * were eligible to vote and then all the votes and then munge them
     * together into a single list of votes.
     * Two queries turns out to be quicker than a single JOIN
     */
    $mps = $pwpdo->fetch_all_rows(
        "SELECT mp_id, gid, person FROM pw_mp WHERE house = ? AND pw_mp.entered_house <= ? AND pw_mp.left_house >= ?",
        array($house, $date, $date)
    );

    /*
     * Get a hash keyed by mp id to make joining with the mp list easier
     */
    $pwpdo->query(
        "SELECT mp_id, vote FROM pw_vote WHERE division_id = ?",
        array($division_id)
    );
    $votes_cast = $pwpdo->statement->fetchAll(PDO::FETCH_COLUMN|PDO::FETCH_GROUP);

    $counts = array(
        'no' => 0,
        'yes' => 0,
        'both' => 0,
        'absent' => 0
    );
    $votes = array();

    foreach ($mps as $mp) {
        $vote = array(
            "id" => 'uk.org.publicwhip/person/' . $mp['person'],
            "option" => ( array_key_exists($mp['mp_id'], $votes_cast) ? $votes_cast[$mp['mp_id']][0] : 'absent' )
        );

        // it is possible to actually say you are abstaining in scotland
        if ( $vote['option'] == 'abstention' ) {
            $vote['option'] = 'both';
        }
        $vote_count++;
        switch( $vote['option'] ) {
            case 'tellno':
                $counts['no']++;
                break;
            case 'aye':
            case 'tellaye':
                $counts['yes']++;
                break;
            case NULL:
                $counts['absent']++;
                break;
            default:
                $counts[$vote['option']]++;
        }
        $votes[] = $vote;
    }


    $counts = array_map( 'fix_counts', array_keys($counts), $counts );
    $pw_votes = array(
        'counts' => $counts,
        'votes' => $votes
    );

    return $pw_votes;
}

function save_to_json_file($data, $file) {
    global $output_dir;
    $json = json_encode($data);
    file_put_contents($output_dir . $file, $json);
}


