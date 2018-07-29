<?php
if (isset($headerAlreadyRan)) {
    error_log('Header already output');
    return;
}
global $headtitle,$title,$h1title;
$headerAlreadyRan=true;
# $Id: header.inc,v 1.105 2011/04/11 13:25:23 publicwhip Exp $

# The Public Whip, Copyright (C) 2003 Francis Irving and Julian Todd
# This is free software, and you are welcome to redistribute it under
# certain conditions.  However, it comes with ABSOLUTELY NO WARRANTY.
# For details see the file LICENSE.html in the top level of the source.

# title bar if not set
if (!isset($headtitle))
{
    $headtitle = preg_replace("/<[^>]*>/", "", $title);
    $headtitle = preg_replace("/ - /", " &#8212; ", $headtitle." - The Public Whip");
    if (!$title) {
        $title ='Counting votes on your behalf';
    }
    $headtitle = "The Public Whip &#8212; ".$title;
}
if (!isset($h1title))
    $h1title = "<h1> ".str_replace(" - ", " &#8212; ", $title)." </h1>";

?>
<!DOCTYPE HTML>
<html>

<head>
<meta charset="UTF-8">

<link href="/style201807.css" type="text/css" rel="stylesheet" media="all">
<!--[if IE 7]>
<link href="/ie7.css" type="text/css" rel="stylesheet" media="all">

<![endif]-->

<link href="/publicwhip_print.css" type="text/css" rel="stylesheet" media="print">
<link rel="alternate" type="application/rss+xml" title="RSS" href="https://www.publicwhip.org.uk/feeds/interestingdivisions.xml" />
<title><?php print $headtitle ?></title>
<script type="text/javascript">
function secondnav_goto() {
    if (!document) return
    if (!document.getElementById) return
    var el = document.getElementById('r')
    window.location=el.options[el.selectedIndex].value
}
function secondnav_goto2() {
    if (!document) return
    if (!document.getElementById) return
    var el = document.getElementById('r2')
    window.location=el.options[el.selectedIndex].value
}
function secondnav_goto3() {
    if (!document) return
    if (!document.getElementById) return
    var el = document.getElementById('r3')
    window.location=el.options[el.selectedIndex].value
}
function ClickSup(nsup) {
    var el = document.getElementById('footnote-' + nsup);
    el.style.backgroundColor = (el.style.backgroundColor ? "" : "#ffff77");
    var sups = document.getElementsByTagName("sup");
    for (var i = 0; i < sups.length; i++)
        if (sups[i].className == "sup-" + nsup)
            sups[i].style.backgroundColor = el.style.backgroundColor;
}
</script>
</head>

<body>
<div id="whitebox">
<script type="text/javascript" src="/walterzorn/wz_tooltip.js"></script>

<div id="header" class="widewidth">
<div class="logo"><a href="/"><img src="/images/logo.jpg" alt="the Public Whip" /></a></div>
<div class="search"><form class="searchtitlebarform" action="/search.php" name=pw>
Search: <input maxLength=256 size=12 id="query_head" name="query" onblur="fadeout(this)" onfocus="fadein(this)" value="" /> <input type="submit" value="Go" name="button" />
</form></div>


<!-- the main site navigation -->
<div id="nav_main">
<a title="Front page and site highlights" href="/index.php">Home</a>
<a title="List of all votes in Parliament" href="/divisions.php">Divisions</a>
<a title="List of all Members of House of Commons" href="/mps.php">MPs</a>
<a title="List of all Members of House of Lords" href="/mps.php?house=lords">Lords</a>
<a title="List of all Members of the Scottish Parliament" href="/mps.php?house=scotland">MSPs</a>
<a title="Help to analyze MP's votes" href="/policies.php">Policies</a>
<a title="Twitter" href="https://twitter.com/publicwhip">Twitter</a>
<!-- <a title="Help run the Public Whip project" href="/project/index.php">Join Us</a> -->
<a title="Frequently asked questions" href="/faq.php">Help / FAQ</a>
</div>

</div><!-- end header-->
<div id="main" class="widewidth"><!-- main content -->
<?php

print $h1title;  # the actual heading
global $second_links,$second_links2,$second_links3,$second_type;

if (isset($second_links)) {
    /**
<!-- the second tier navigation as dropdowns -->
<!-- add hashes to $second_links array, keys are
     'href' - URL of link
     'text' - displayed text
     'tooltip' - text to put in title
     'current' - 'on' or 'off' for whether this item is currently selected --> **/
    function print_links_default($links, $offset) {
        print '<form name="secondnav" action="/redir.php" method="post" style="display: inline">';
        print '<select id="r'.$offset.'" name="r'.$offset.'" onchange="secondnav_goto'.$offset.'()">';
        foreach ($links as $this_link) {
    #       print "<a title=\"".$this_link['tooltip']."\" href=\"".$this_link['href']."\" class=\"".$this_link['current']."\">".$this_link['text']."</a> ";
            print "<option title=\"".$this_link['tooltip']."\" value=\"".$this_link['href']."\" ";
            if ($this_link['current'] == 'on')
                print "selected ";
            print 'onclick="secondnav_goto'.$offset.'()" ';
            print "class=\"".$this_link['current']."\">";
            print $this_link['text'];
            print "</option> ";
        }
        print '</select> ';
        print ' <input type="submit" name="submit" value="Go">';
        print '</form> ';
    }

    print_links_default($second_links, "");
    if ($second_links2)
    {
    	print_links_default($second_links2, "2");
        if ($second_links3)
	    	print_links_default($second_links3, "3");
    }
?>
<!-- the second tier navigation as dropdowns end-->
<?php }