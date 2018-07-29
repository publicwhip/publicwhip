#!/usr/bin/perl -w
use strict;
use lib "PublicWhip";

# Convert all-members.xml and all-lords.xml into the database format for Public
# Whip website

# The Public Whip, Copyright (C) 2003 Francis Irving and Julian Todd
# This is free software, and you are welcome to redistribute it under
# certain conditions.  However, it comes with ABSOLUTELY NO WARRANTY.
# For details see the file LICENSE.html in the top level of the source.

use XML::Twig;
use HTML::Entities;
use Data::Dumper;
use File::Slurp;
use JSON;

use PublicWhip::Config;
my $members_location = $PublicWhip::Config::members_location;

use PublicWhip::Error;
use PublicWhip::DB;
my $dbh = PublicWhip::DB::connect();

sub debug {
    my $log = shift;
    my ($sec,$min,$hour,$mday,$mon,$year) = localtime(time);
    printf "[%4d-%02d-%02d %02d:%02d:%02d] %s: %s\n",$year+1900,$mon+1,$mday,$hour,$min,$sec,"memxml2db", $log;
}

debug("Mapping gid to internal mp_ids");

# Map from gid to the pw_mp.mp_id internal Public Whip ids, so we reload
# table with same new ids
our $gid_to_internal;
our (%organizations, %posts, %people);
my $last_mp_id = 0;
my $sth = PublicWhip::DB::query($dbh, "select mp_id, gid from pw_mp");
while ( my ($mp_id, $gid) = $sth->fetchrow_array() ) {
    $gid_to_internal->{$gid} = $mp_id;
    $last_mp_id = $mp_id if ($mp_id > $last_mp_id);
}

debug("Deleting tables");
# We completely rebuild these two tables
$sth = PublicWhip::DB::query($dbh, "delete from pw_moffice");
$sth = PublicWhip::DB::query($dbh, "delete from pw_constituency");

my %membertoperson;
debug("Parsing constituencies.json");
loadcons('commons', $members_location. '/constituencies.json');

debug("Parsing sp-constituencies.json");
loadcons('scotland', $members_location. '/sp-constituencies.json');

debug("Parsing people.json");
loadpeople();

debug("Parsing ministers.xml");
loadmoffice();

debug("Deleting cached");
# Delete things left that shouldn't be from this table
foreach my $gid (keys %$gid_to_internal) {
    $sth = PublicWhip::DB::query($dbh, "delete from pw_mp where gid = '$gid'");
}

sub loadpeople
{
    my $j = decode_json(read_file($members_location. '/people.json'));
    foreach (@{$j->{persons}}) {
        $people{$_->{id}} = $_;
    }
    foreach (@{$j->{organizations}}) {
        $organizations{$_->{id}} = $_;
    }
    foreach (@{$j->{posts}}) {
        $posts{$_->{id}} = $_;
    }
    foreach (@{$j->{memberships}}) {
        loadmember($_);
    }
}

sub loadmember
{
    my $memb = shift;

    my $fromdate = $memb->{start_date} || '0000-00-00';
    $fromdate .= '-00-00' if length($fromdate) == 4;
    my $todate = $memb->{end_date} || '9999-12-31';
    $todate .= '-00-00' if length($todate) == 4;

    my $org_slug;
    if ($memb->{post_id}) {
        $org_slug = $posts{$memb->{post_id}}{organization_id};
    } else {
        $org_slug = $memb->{organization_id};
    }
    return unless $org_slug; # A redirected membership

    my $house = '';
    if ( $org_slug eq 'house-of-commons' ) {
        $house = 'commons';
    } elsif ( $org_slug eq 'scottish-parliament' ) {
        $house = 'scotland';
    } elsif ( $org_slug eq 'house-of-lords' ) {
        $house = 'lords';
    } else {
        # $org_slug will be 'northern-ireland-assembly' or 'crown'
        return;
    }

    my $gid = $memb->{id};
    if ($gid =~ m#uk.org.publicwhip/member/#) {
        die unless ($house eq 'commons' || $house eq 'scotland');
    } elsif ($gid =~ m#uk.org.publicwhip/lord/#) {
        die if $house ne 'lords';
    } else {
        die "unknown gid type $gid";
    }

    my $id = $gid;
    # /member and /lord ids are from same numberspace
    $id =~ s#uk.org.publicwhip/member/##;
    $id =~ s#uk.org.publicwhip/lord/##;

    (my $person_id = $memb->{person_id}) =~ s#uk.org.publicwhip/person/##;
    my $person = $people{$memb->{person_id}};
    die "$house $id person ID $memb->{person_id} has no person" unless $person;

    my @names = grep { $_->{note} eq 'Main' } @{$person->{other_names}};
    @names = grep { ($_->{start_date} || '0000-00-00') le $todate && ($_->{end_date} || '9999-12-31') ge $todate } @names;
    $memb->{name} = $names[0];

    my $last_name_field = $org_slug eq 'house-of-lords' ? 'lordname' : 'family_name';
    my $constituency = '';
    if ($org_slug eq 'house-of-lords') {
        $constituency = $memb->{name}{lordofname};
    } elsif ($org_slug ne 'crown') {
        $constituency = $posts{$memb->{post_id}}{area}{name};
    }

    my $party = $memb->{on_behalf_of_id} ? $organizations{$memb->{on_behalf_of_id}}{name} : '';
    $party = Encode::encode('iso-8859-1', $party);

    # party names are used hard coded in various places in code so we need to use
    # the old style ones
    if ( $party eq 'Conservative' ) {
        $party = 'Con';
    } elsif ( $party eq 'Labour' or $party eq 'Labour/Co-operative' ) {
        $party = 'Lab';
    } elsif ( $party eq 'Liberal Democrat' ) {
        $party = 'LDem';
    } elsif ( $party eq 'Scottish National Party' ) {
        $party = 'SNP';
    } elsif ( $party eq 'Social Democratic and Labour Party' ) {
        $party = 'SDLP';
    } elsif ( $party eq 'Plaid Cymru' ) {
        $party = 'PC';
    } elsif ( $party eq 'Speaker' ) {
        $party = 'SPK';
    } elsif ( $party =~ /Sinn/ ) {
        $party = 'SF';
    }

    my $title = $memb->{name}->{honorific_prefix} || '';
    my $firstname = $memb->{name}->{given_name};
    my $lastname = $memb->{name}->{$last_name_field};

    if ($todate le '1997-04-08') {
        #print "Ignoring entry older than 1997 election for $firstname $lastname $fromdate $todate\n";
        return;
    }
    if ($fromdate !~ m/\d\d\d\d-\d\d-\d\d/ && $todate !~ m/\d\d\d\d-\d\d-\d\d/) {
        print "Ignoring entry with doubly incomplete date for $firstname $lastname $fromdate $todate\n";
        return;
    }
    my $fromwhy = $memb->{start_reason} || '';
    my $towhy = $memb->{end_reason} || ($todate eq '9999-12-31' && $org_slug ne 'house-of-lords' ? 'still_in_office' : '');
    if ($house eq 'lords') {
        if (!$memb->{name}->{lordname}) {
            $title = "The " . $title;
        }
        $firstname = $memb->{name}->{lordname};
        if ($memb->{name}->{lordofname}) {
            $lastname = "of " . $memb->{name}->{lordofname};
        } else {
            $lastname = "";
        }
        $constituency = "";
        $party = 'LDem' if ($party eq 'Dem');
        $fromwhy = 'unknown'; # TODO
        $towhy = 'unknown';
        if (!$todate) {
            $todate = "9999-12-31"; # TODO
        }
    }

    # We encode entities as e.g. &Ouml;, as otherwise non-ASCII characters
    # get lost somewhere between Perl, the database and the browser.
    my $sth = PublicWhip::DB::query($dbh, "delete from pw_mp where gid = '$gid'");
    if (!defined $firstname) {
        $firstname = "[Missing first name for ".$id."]"; # rab
    }
    if (!defined $lastname) {
        $lastname = "[Missing last name for ".$id."]"; # rab
    }
    $sth = PublicWhip::DB::query($dbh, "insert into pw_mp
        (first_name, last_name, title, constituency, party, house,
        entered_house, left_house, entered_reason, left_reason, 
        mp_id, person, gid) values
        (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
            encode_entities($firstname),
            encode_entities($lastname),
            $title,
            encode_entities($constituency),
            $party,
            $house,
            $fromdate, 
            $todate, 
            $fromwhy, 
            $towhy, 
            $id,
            $person_id,
            $gid,
        );

    # Store deleted
    delete $gid_to_internal->{$gid};

}

sub loadmoffice
{ 
    foreach ('ministers.json', 'ministers-2010.json') {
        my $j = decode_json(read_file($members_location . $_));
        foreach (@{$j->{organizations}}) {
            $organizations{$_->{id}} = $_->{name};
        }
        foreach (@{$j->{memberships}}) {
            (my $person = $_->{person_id}) =~ s#uk.org.publicwhip/person/##;
            my $position = $_->{role} || 'Member';
            my $dept = $organizations{$_->{organization_id}} || die $!;
            $dept = '' if $dept eq 'House of Commons';
            my $end_date = $_->{end_date} || '9999-12-31';

            my $responsibility = ''; # $_->{role} ? $_->{role} : '';
            my $sth = PublicWhip::DB::query($dbh, "insert into pw_moffice
                (dept, position, responsibility,
                from_date, to_date, person) values
                (?, ?, ?, ?, ?, ?)",
                encode_entities($dept),
                encode_entities($position),
                encode_entities($responsibility),
                $_->{start_date},
                $end_date,
                $person,
                );
        }
    }
}

sub loadcons
{
    my $house = shift;
    my $file = shift;
    my $j = decode_json(read_file($file));
    foreach my $cons (@$j) {

        (my $consid = $cons->{id}) =~ s#uk.org.publicwhip/cons/##;

        my $start_date = $cons->{start_date};
        $start_date .= '-00-00' if length($start_date) == 4;
        my $end_date = $cons->{end_date} || '9999-12-31';
        $end_date .= '-00-00' if length($end_date) == 4;

        my $main_name = 1;
        foreach my $name (@{$cons->{names}}) {
            my $sth = PublicWhip::DB::query($dbh, "insert into pw_constituency
                (cons_id, name, main_name, from_date, to_date, house) values
                (?, ?, ?, ?, ?, ?)",
                $consid,
                encode_entities(Encode::encode('iso-8859-1', $name)),
                $main_name,
                $start_date,
                $end_date,
                $house
            );
            $main_name = 0;
        }
    }
}
