<?php
# $Id: cache-tools.inc,v 1.3 2004/06/15 23:46:49 frabcus Exp $

# The Public Whip, Copyright (C) 2003 Francis Irving and Julian Todd
# This is free software, and you are welcome to redistribute it under
# certain conditions.  However, it comes with ABSOLUTELY NO WARRANTY.
# For details see the file LICENSE.html in the top level of the source.

function newsletter_navbar() {
    $ret = "";
    if (!user_isloggedin()) {
        $ret .= '<a title="Subscribe to our email newsletter" href="/account/register.php">Newsletter</a>';
    } else {
        $ret .= '<a title="Email newsletter archives" href="/newsletters/archive.php">Newsletter</a>';
    }
    return $ret;
}

function account_navbar() {
    $ret = "";
    if (user_isloggedin()) {
        global $user_name;
        $ret .= $user_name . " ";
        $ret .= '<a title="Change account settings, such as whether you get the newsletter" href="/account/settings.php">';
        $ret .= "Settings";
        $ret .= '</a>';
        $ret .= '<a title="Make your browser forget that you are logged into The Public Whip as ' . $user_name .'" href="/account/logout.php">';
        $ret .= "Logout";
        $ret .= '</a>';
    } else {
        $ret .= '<a title="Login to edit your Dream MPs or change your newsletter settings" href="/account/settings.php">';
        $ret .= "Login";
        $ret .= '</a>';
        $ret .= '<a title="Register to get a newsletter or make a Dream MP" href="/account/register.php">';
        $ret .= "Signup";
        $ret .= '</a>';
    }
    return $ret;
}

function cache_delete($file_stub, $cache_params) {
    $cache_dir = "/home/francis/pwcache/" . substr(str_replace("/", "-", $_SERVER["SCRIPT_NAME"]),1);
    $cache_dir = str_replace("account-", "", $cache_dir);
    $cache_dir = str_replace(strrchr($cache_dir, "-"), "-" . $file_stub, $cache_dir);

    $cache_file = $cache_dir . "/" . $cache_params . ".html";


    foreach (glob($cache_file) as $filename) {
        #print "delete $filename\n<p>";
        unlink($filename);
    }

    #if (file_exists($cache_file))
#        unlink($cache_file);
}

?>