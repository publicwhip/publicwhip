/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pw_cache_attendrank_today`
--

DROP TABLE IF EXISTS `pw_cache_attendrank_today`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_attendrank_today` (
 `mp_id` int(11) NOT NULL,
 `attend_rank` int(11) NOT NULL,
 `attend_outof` int(11) NOT NULL,
 KEY `mp_id` (`mp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_divdiv_distance`
--

DROP TABLE IF EXISTS `pw_cache_divdiv_distance`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_divdiv_distance` (
 `division_id` int(11) NOT NULL default '0',
 `division_id2` int(11) NOT NULL default '0',
 `nvotespossible` smallint(6) default NULL,
 `nvotessame` smallint(6) default NULL,
 `nvotesdiff` smallint(6) default NULL,
 `nvotesabsent` int(11) default NULL,
 `distance` float default NULL,
 UNIQUE KEY `division_id_2` (`division_id`,`division_id2`),
 KEY `division_id` (`division_id`),
 KEY `division_id2` (`division_id2`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_divinfo`
--

DROP TABLE IF EXISTS `pw_cache_divinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_divinfo` (
 `division_id` int(11) NOT NULL,
 `rebellions` int(11) NOT NULL,
 `tells` int(11) NOT NULL,
 `turnout` int(11) NOT NULL,
 `possible_turnout` int(11) NOT NULL,
 `aye_majority` int(11) NOT NULL,
 KEY `division_id` (`division_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_divwiki`
--

DROP TABLE IF EXISTS `pw_cache_divwiki`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_divwiki` (
 `division_date` date NOT NULL default '0000-00-00',
 `division_number` int(11) NOT NULL default '0',
 `wiki_id` int(11) NOT NULL default '0',
 `house` enum('commons','lords','scotland') collate utf8_unicode_ci NOT NULL,
 UNIQUE KEY `division_date` (`division_date`,`division_number`,`house`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_dreaminfo`
--

DROP TABLE IF EXISTS `pw_cache_dreaminfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_dreaminfo` (
 `dream_id` int(11) NOT NULL default '0',
 `votes_count` int(11) NOT NULL default '0',
 `edited_motions_count` int(11) NOT NULL default '0',
 `consistency_with_mps` float default NULL,
 `cache_uptodate` int(11) NOT NULL default '0',
 PRIMARY KEY  (`dream_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_dreamreal_distance`
--

DROP TABLE IF EXISTS `pw_cache_dreamreal_distance`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_dreamreal_distance` (
 `dream_id` int(11) NOT NULL default '0',
 `person` int(11) NOT NULL default '0',
 `nvotessame` int(11) default NULL,
 `nvotessamestrong` int(11) default NULL,
 `nvotesdiffer` int(11) default NULL,
 `nvotesdifferstrong` int(11) default NULL,
 `nvotesabsent` int(11) default NULL,
 `nvotesabsentstrong` int(11) default NULL,
 `distance_a` float default NULL,
 `distance_b` float default NULL,
 UNIQUE KEY `rollie_id_2` (`dream_id`,`person`),
 KEY `rollie_id` (`dream_id`),
 KEY `person` (`person`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_mpinfo`
--

DROP TABLE IF EXISTS `pw_cache_mpinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_mpinfo` (
 `mp_id` int(11) NOT NULL,
 `rebellions` int(11) NOT NULL,
 `tells` int(11) NOT NULL,
 `votes_attended` int(11) NOT NULL,
 `votes_possible` int(11) NOT NULL,
 `aye_majority` int(11) NOT NULL,
 KEY `mp_id` (`mp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_mpinfo_session2002`
--

DROP TABLE IF EXISTS `pw_cache_mpinfo_session2002`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_mpinfo_session2002` (
 `mp_id` int(11) NOT NULL default '0',
 `rebellions` int(11) NOT NULL default '0',
 `tells` int(11) NOT NULL default '0',
 `votes_attended` int(11) NOT NULL default '0',
 `votes_possible` int(11) NOT NULL default '0',
 KEY `mp_id` (`mp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_partyinfo`
--

DROP TABLE IF EXISTS `pw_cache_partyinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_partyinfo` (
 `party` varchar(100) collate utf8_unicode_ci NOT NULL,
 `house` enum('commons','lords','scotland') collate utf8_unicode_ci NOT NULL,
 `total_votes` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_realreal_distance`
--

DROP TABLE IF EXISTS `pw_cache_realreal_distance`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_realreal_distance` (
 `mp_id1` int(11) NOT NULL default '0',
 `mp_id2` int(11) NOT NULL default '0',
 `nvotessame` int(11) default NULL,
 `nvotesdiffer` int(11) default NULL,
 `nvotesabsent` int(11) default NULL,
 `distance_a` float default NULL,
 `distance_b` float default NULL,
 UNIQUE KEY `mp_id1_2` (`mp_id1`,`mp_id2`),
 KEY `mp_id1` (`mp_id1`),
 KEY `mp_id2` (`mp_id2`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_rebelrank_today`
--

DROP TABLE IF EXISTS `pw_cache_rebelrank_today`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_rebelrank_today` (
 `mp_id` int(11) NOT NULL,
 `rebel_rank` int(11) NOT NULL,
 `rebel_outof` int(11) NOT NULL,
 KEY `mp_id` (`mp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_cache_whip`
--

DROP TABLE IF EXISTS `pw_cache_whip`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_cache_whip` (
 `division_id` int(11) NOT NULL,
 `party` varchar(200) collate utf8_unicode_ci NOT NULL,
 `aye_votes` int(11) NOT NULL,
 `aye_tells` int(11) NOT NULL,
 `no_votes` int(11) NOT NULL,
 `no_tells` int(11) NOT NULL,
 `both_votes` int(11) NOT NULL,
 `abstention_votes` int(11) NOT NULL,
 `possible_votes` int(11) NOT NULL,
 `whip_guess` enum('aye','no','abstention','unknown','none') collate utf8_unicode_ci NOT NULL,
 UNIQUE KEY `division_id` (`division_id`,`party`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_candidate`
--

DROP TABLE IF EXISTS `pw_candidate`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_candidate` (
 `candidate_id` int(11) NOT NULL,
 `first_name` varchar(100) NOT NULL,
 `last_name` varchar(100) NOT NULL,
 `constituency` varchar(100) NOT NULL,
 `party` varchar(100) NOT NULL,
 `house` enum('commons','lords') NOT NULL,
 `became_candidate` date NOT NULL default '1000-01-01',
 `left_candidate` date NOT NULL default '9999-12-31',
 `url` text NOT NULL,
 PRIMARY KEY  (`candidate_id`),
 UNIQUE KEY `first_name` (`first_name`,`last_name`,`constituency`,`became_candidate`,`left_candidate`),
 KEY `house` (`house`),
 KEY `party` (`party`),
 KEY `became_candidate` (`became_candidate`),
 KEY `left_candidate` (`left_candidate`),
 KEY `constituency` (`constituency`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_constituency`
--

DROP TABLE IF EXISTS `pw_constituency`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_constituency` (
 `cons_id` int(11) NOT NULL default '0',
 `name` varchar(100) collate utf8_unicode_ci NOT NULL default '',
 `main_name` tinyint(1) NOT NULL default '0',
 `from_date` date NOT NULL default '1000-01-01',
 `to_date` date NOT NULL default '9999-12-31',
 `house` enum('commons','scotland') collate utf8_unicode_ci NOT NULL default 'commons',
 KEY `from_date` (`from_date`),
 KEY `to_date` (`to_date`),
 KEY `name` (`name`),
 KEY `cons_id` (`cons_id`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_division`
--

DROP TABLE IF EXISTS `pw_division`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_division` (
 `division_id` int(11) NOT NULL auto_increment,
 `valid` tinyint(1) default NULL,
 `division_date` date NOT NULL default '0000-00-00',
 `division_number` int(11) NOT NULL default '0',
 `division_name` blob NOT NULL,
 `source_url` blob NOT NULL,
 `motion` blob NOT NULL,
 `notes` blob NOT NULL,
 `debate_url` blob NOT NULL,
 `source_gid` mediumtext collate utf8_unicode_ci NOT NULL,
 `debate_gid` mediumtext collate utf8_unicode_ci NOT NULL,
 `house` enum('commons','lords','scotland') collate utf8_unicode_ci NOT NULL,
 `clock_time` mediumtext collate utf8_unicode_ci,
 PRIMARY KEY  (`division_id`),
 UNIQUE KEY `division_date_3` (`division_date`,`division_number`,`house`),
 KEY `division_number` (`division_number`),
 KEY `division_date_2` (`division_date`),
 KEY `house` (`house`)
) ENGINE=MyISAM AUTO_INCREMENT=30501 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_auditlog`
--

DROP TABLE IF EXISTS `pw_dyn_auditlog`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_auditlog` (
 `auditlog_id` int(11) NOT NULL auto_increment,
 `user_id` int(11) NOT NULL default '0',
 `event_date` datetime default NULL,
 `event` mediumtext collate utf8_unicode_ci,
 `remote_addr` mediumtext collate utf8_unicode_ci,
 PRIMARY KEY  (`auditlog_id`)
) ENGINE=MyISAM AUTO_INCREMENT=74068 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_crewe_comments`
--

DROP TABLE IF EXISTS `pw_dyn_crewe_comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_crewe_comments` (
 `vkey` varchar(20) default NULL,
 `ltime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
 `vrand` int(11) default NULL,
 `vvote` varchar(20) default NULL,
 `vinitials` varchar(20) default NULL,
 `vpostcode` varchar(20) default NULL,
 `vcomment` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_dreammp`
--

DROP TABLE IF EXISTS `pw_dyn_dreammp`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_dreammp` (
 `dream_id` int(11) NOT NULL auto_increment,
 `name` varchar(100) collate utf8_unicode_ci NOT NULL default '',
 `user_id` int(11) NOT NULL default '0',
 `description` blob NOT NULL,
 `private` tinyint(1) NOT NULL default '0',
 PRIMARY KEY  (`dream_id`),
 UNIQUE KEY `rollie_id` (`dream_id`,`name`,`user_id`),
 KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1135 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_dreamvote`
--

DROP TABLE IF EXISTS `pw_dyn_dreamvote`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_dreamvote` (
 `division_date` date NOT NULL default '0000-00-00',
 `division_number` int(11) NOT NULL default '0',
 `dream_id` int(11) NOT NULL default '0',
 `vote` enum('aye','no','both','aye3','no3','abstention','spoiled') collate utf8_unicode_ci NOT NULL,
 `house` enum('commons','lords','scotland') collate utf8_unicode_ci NOT NULL,
 UNIQUE KEY `division_date` (`division_date`,`division_number`,`dream_id`,`house`),
 KEY `division_date_2` (`division_date`),
 KEY `division_number` (`division_number`),
 KEY `rolliemp_id` (`dream_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_fortytwoday_comments`
--

DROP TABLE IF EXISTS `pw_dyn_fortytwoday_comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_fortytwoday_comments` (
 `vterdet` varchar(10) default NULL,
 `vpubem` varchar(20) default NULL,
 `ltime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
 `vrand` int(11) default NULL,
 `vpostcode` varchar(20) default NULL,
 `constituency` varchar(80) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_glenrothes_event`
--

DROP TABLE IF EXISTS `pw_dyn_glenrothes_event`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_glenrothes_event` (
 `ltime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
 `vrand` int(11) default NULL,
 `vevent` varchar(30) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_glenrothes_use`
--

DROP TABLE IF EXISTS `pw_dyn_glenrothes_use`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_glenrothes_use` (
 `ltime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
 `vrand` int(11) default NULL,
 `vpostcode` varchar(20) default NULL,
 `vconstituency` varchar(40) default NULL,
 `referrer` varchar(200) default NULL,
 `ipnumber` varchar(25) default NULL,
 `vdash` varchar(7) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_newsletter`
--

DROP TABLE IF EXISTS `pw_dyn_newsletter`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_newsletter` (
 `newsletter_id` int(11) NOT NULL auto_increment,
 `email` varchar(255) collate utf8_unicode_ci default NULL,
 `token` mediumtext collate utf8_unicode_ci NOT NULL,
 `confirm` tinyint(4) default NULL,
 `subscribed` datetime default NULL,
 PRIMARY KEY  (`newsletter_id`),
 UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=12919 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_newsletters_sent`
--

DROP TABLE IF EXISTS `pw_dyn_newsletters_sent`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_newsletters_sent` (
 `newsletter_id` int(11) NOT NULL default '0',
 `newsletter_name` varchar(100) collate utf8_unicode_ci NOT NULL default '',
 UNIQUE KEY `newsletter_id` (`newsletter_id`,`newsletter_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_user`
--

DROP TABLE IF EXISTS `pw_dyn_user`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_user` (
 `user_id` int(11) NOT NULL auto_increment,
 `user_name` mediumtext collate utf8_unicode_ci,
 `real_name` mediumtext collate utf8_unicode_ci,
 `email` mediumtext collate utf8_unicode_ci,
 `password` mediumtext collate utf8_unicode_ci,
 `remote_addr` mediumtext collate utf8_unicode_ci,
 `confirm_hash` mediumtext collate utf8_unicode_ci,
 `is_confirmed` int(11) NOT NULL default '0',
 `reg_date` datetime default NULL,
 `active_policy_id` int(11) default NULL,
 `confirm_return_url` mediumtext collate utf8_unicode_ci,
 PRIMARY KEY  (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=50692 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_dyn_wiki_motion`
--

DROP TABLE IF EXISTS `pw_dyn_wiki_motion`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_dyn_wiki_motion` (
 `wiki_id` int(11) NOT NULL auto_increment,
 `text_body` mediumtext collate utf8_unicode_ci NOT NULL,
 `user_id` int(11) NOT NULL default '0',
 `edit_date` datetime default NULL,
 `division_date` date NOT NULL default '0000-00-00',
 `division_number` int(11) NOT NULL default '0',
 `house` enum('commons','lords','scotland') collate utf8_unicode_ci NOT NULL,
 PRIMARY KEY  (`wiki_id`),
 KEY `division_date` (`division_date`,`division_number`,`house`)
) ENGINE=MyISAM AUTO_INCREMENT=4075 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_logincoming`
--

DROP TABLE IF EXISTS `pw_logincoming`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_logincoming` (
 `referrer` varchar(120) collate utf8_unicode_ci default NULL,
 `ltime` datetime default NULL,
 `ipnumber` varchar(20) collate utf8_unicode_ci default NULL,
 `page` varchar(20) collate utf8_unicode_ci default NULL,
 `subject` varchar(60) collate utf8_unicode_ci default NULL,
 `url` varchar(120) collate utf8_unicode_ci default NULL,
 `thing_id` int(11) default NULL,
 KEY `ltime` (`ltime`),
 KEY `thing_id` (`thing_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_moffice`
--

DROP TABLE IF EXISTS `pw_moffice`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_moffice` (
 `moffice_id` int(11) NOT NULL auto_increment,
 `dept` varchar(100) collate utf8_unicode_ci NOT NULL default '',
 `position` varchar(100) collate utf8_unicode_ci NOT NULL default '',
 `from_date` date NOT NULL default '1000-01-01',
 `to_date` date NOT NULL default '9999-12-31',
 `person` int(11) default NULL,
 `responsibility` varchar(100) collate utf8_unicode_ci NOT NULL default '',
 PRIMARY KEY  (`moffice_id`),
 KEY `person` (`person`)
) ENGINE=MyISAM AUTO_INCREMENT=6105 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_mp`
--

DROP TABLE IF EXISTS `pw_mp`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_mp` (
 `mp_id` int(11) NOT NULL auto_increment,
 `first_name` varchar(50) collate utf8_unicode_ci NOT NULL,
 `last_name` varchar(50) collate utf8_unicode_ci NOT NULL,
 `title` varchar(50) collate utf8_unicode_ci NOT NULL,
 `constituency` varchar(100) collate utf8_unicode_ci NOT NULL default '',
 `party` varchar(100) collate utf8_unicode_ci NOT NULL default '',
 `entered_house` date NOT NULL default '1000-01-01',
 `left_house` date NOT NULL default '9999-12-31',
 `entered_reason` enum('unknown','general_election','by_election','changed_party','reinstated') collate utf8_unicode_ci NOT NULL default 'unknown',
 `left_reason` enum('unknown','still_in_office','general_election','general_election_standing','general_election_not_standing','changed_party','died','declared_void','resigned','disqualified','became_peer') collate utf8_unicode_ci NOT NULL default 'unknown',
 `person` int(11) default NULL,
 `house` enum('commons','lords','scotland') collate utf8_unicode_ci NOT NULL,
 `gid` varchar(100) collate utf8_unicode_ci NOT NULL,
 PRIMARY KEY  (`mp_id`),
 UNIQUE KEY `title` (`title`,`first_name`,`last_name`,`constituency`,`entered_house`,`left_house`,`house`),
 KEY `person` (`person`),
 KEY `entered_house` (`entered_house`),
 KEY `left_house` (`left_house`),
 KEY `house` (`house`),
 KEY `pw_mp_gid` (`gid`)
) ENGINE=MyISAM AUTO_INCREMENT=101135 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_vote`
--

DROP TABLE IF EXISTS `pw_vote`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_vote` (
 `division_id` int(11) NOT NULL default '0',
 `mp_id` int(11) NOT NULL default '0',
 `vote` enum('aye','no','both','tellaye','tellno','abstention','spoiled') collate utf8_unicode_ci NOT NULL,
 UNIQUE KEY `division_id_2` (`division_id`,`mp_id`,`vote`),
 KEY `division_id` (`division_id`),
 KEY `mp_id` (`mp_id`),
 KEY `vote` (`vote`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pw_vote_sortorder`
--

DROP TABLE IF EXISTS `pw_vote_sortorder`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pw_vote_sortorder` (
 `vote` enum('aye','no','both','tellaye','tellno') collate utf8_unicode_ci NOT NULL default 'aye',
 `position` int(11) NOT NULL default '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
SET character_set_client = @saved_cs_client;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
