#! /usr/bin/perl -w 
use strict;

# $Id: cluster-animation.pl,v 1.1 2003/09/19 16:06:36 frabcus Exp $
# Outputs a matrix of distances between pairs of MPs for
# use by the GNU Octave script mds.m to do clustering.

# The Public Whip, Copyright (C) 2003 Francis Irving and Julian Todd
# This is free software, and you are welcome to redistribute it under
# certain conditions.  However, it comes with ABSOLUTELY NO WARRANTY.
# For details see the file LICENSE.html in the top level of the source.

use Date::Parse;

require "../scraper/db.pm";
my $dbh = db::connect();

# Count MPs (which have voted at least once)
require "mpquery.pm";
my $mp_ixs = mpquery::get_mp_ixs($dbh, "votes_attended > 0", "limit 20");

# Find number of divisions
my $sth = db::query($dbh, "select count(*) from pw_division order by division_date, division_number");
my @data = $sth->fetchrow_array();
my $divcount = $data[0];

# Work out distance metric
my $date = str2time("2001-06-26");
my $window = "INTERVAL 3 MONTH";
my $end = str2time("2003-03-01");
my $step = 60*60*24*7; # one week
for (; $date < $end; $date += $step)
{
    my $metricD = mpquery::vote_distance_metric($dbh, $mp_ixs, 
        "where division_date>=FROM_UNIXTIME($date) and division_date<=DATE_ADD(FROM_UNIXTIME($date), $window)");

    # Feed to octave
    open(PIPE, ">DN.m");
    mpquery::octave_writer(\*PIPE, $dbh, $mp_ixs, $metricD);
    system("octave --silent mds.m");

    # Move octaves output out the way
    use POSIX qw(strftime);
    my $name = strftime "anim/mpcoords-%Y-%m-%d.txt", gmtime($date);
    rename "mpcoords.txt",$name;
}

