<?php

#print "Public Whip is down for maintenance. When it is back up it will have some new things for you though :)";
#exit;

# $Id: common.inc,v 1.27 2011/04/11 13:20:43 publicwhip Exp $

# Included from all main .php files on the first line

# The Public Whip, Copyright (C) 2003 Francis Irving and Julian Todd
# This is free software, and you are welcome to redistribute it under
# certain conditions.  However, it comes with ABSOLUTELY NO WARRANTY.
# For details see the file LICENSE.html in the top level of the source.

#print "Sorry about this, but Public Whip is unavailable for a few minutes due to maintenance. We'll be back up shortly.";
#exit;

require_once __DIR__.'/config.php';
require_once __DIR__.'/cache-tools.inc';

ini_set('log_errors', 'On');
ini_set('log_errors_max_len', '0');
ini_set('error_log', null);
ini_set('ignore_repeated_errors', 'Off');
ini_set('html_errors', 'Off');
if (version_compare(PHP_VERSION, "5.0", ">="))
    date_default_timezone_set("Europe/London");

if (get_magic_quotes_gpc()) {
    trigger_error("Public Whip only works with magic_quotes_gpc off in php.ini", E_USER_ERROR);
}
if (ini_get('register_globals')) {
    trigger_error("Public Whip only works with register_globals off in php.ini", E_USER_ERROR);
}


function pw_handle_404($message='Page Not Found',$explain='') {
    global $title,$headtitle,$h1title;
    if (!headers_sent()) {
        header('HTTP/1.0 404 Page Not Found');
    }
    $title='404 Page Not Found: '.$message;
    $headtitle=$title;
    require_once __DIR__.'/header.inc';
    $briefError= [
        'errorType'=>'404',
        'dateStamp'=>date('c'),
        'redirectStatus'=>$_SERVER['REDIRECT_STATUS'] ?? 'not found',
        'url'=>$_SERVER['REDIRECT_URL'] ?? $_SERVER['REQUEST_URI'] ?? 'not found',
        'query'=>$_SERVER['REDIRECT_QUERY_STRING'] ?? $_SERVER['QUERY_STRING'] ?? 'none',
        'host'=>$_SERVER['HTTP_HOST'] ?? 'not found',
        'server'=>$_SERVER['SERVER_NAME'] ?? 'not found',
        'serverPort'=>$_SERVER['SERVER_PORT'] ?? 'not found',
        'method'=>$_SERVER['REDIRECT_REQUEST_METHOD'] ?? $_SERVER['REQUEST_METHOD'] ?? 'not found'
    ];
    global $adminAllowed;
    if ($adminAllowed) {
        $briefError['adminIp']='yes';
    }
    $fullError=array_merge($briefError,
        [
            'userIp'=>$_SERVER['REMOTE_ADDR'] ?? 'none',
            'userAgent'=>$_SERVER['HTTP_USER_AGENT'] ?? 'none',
            'userReferer'=>$_SERVER['HTTP_REFERER'] ?? 'none',
            'userClientIp'=>$_SERVER['HTTP_CLIENT_IP'] ?? 'none',
            'userXForwardedFor'=>$_SERVER['HTTP_X_FORWARDED_FOR'] ?? 'none',
            'userCfConnectingIp'=>$_SERVER['HTTP_CF_CONNECTING_IP'] ?? 'none',
            'userCfRay'=>$_SERVER['HTTP_CF_RAY'] ?? 'none'
        ]
    );
    error_log('404: '.json_encode($fullError));
    ?>
    <p><?php echo $explain; ?></p>

    <p><label for="query">Please feel free to either search for an MP, Lord/Lady, or a postcode:</label></p>

    <form action="/search.php" name="pw" method="get">
        <input maxLength="256" size="150" name="query" id="query" placeholder="Search"> <button type="submit" value="Submit" name="button">Submit</button>
    </form>

    <p>If you think you reached this page in error, please contact us at <a href="mailto:team@publicwhip.org.uk">team@publicwhip.org.uk</a> with
        the following information:<br>
        If you don't mind us knowing your IP address, and web browser (which may help us diagnose issues and the information will only be used for this purpose),
        please send us the following information:<br>
    <pre>
	full:<?php echo chunk_split(base64_encode(json_encode($fullError)),80,'<br>'); ?>:end
</pre><br>
    If, however, you would prefer to keep your IP address, web browser details, please send the following information:<br>
    <pre>
	brief:<?php echo chunk_split(base64_encode(json_encode($briefError)),80,'<br>'); ?>:end
</pre><br>
    </p>
    <h2>What is in this diagnostic information?</h2>
    <p>It is a base64 encoded JSON array containing the error type you encountered,
        the date it occurred, the URL (including hostname and query string and the 'type' [GET or POST]) of the request,
        the name of the server that handled your request and the referral URL (which page you visited before hitting this error).</p>
    <p>If you choose to send us the full information, it also contains your IP address (and those of any proxy servers) and the user agent of your
        web browser which will only be used to assist us in diagnosing issues.</p>
    <?php
    include __DIR__.'/footer.inc';
    exit();
}

// Display errors better
function pw_handle_error($num, $message, $file, $line, $context) {
    global $title;
    if ($num === E_USER_NOTICE || $num === E_NOTICE) {
        // Alas, Public Whip is written to expect no errors when referring to variable undefined
        // If you're bored, please remove this check and fix lots of the bugs and commit :)
        return;
    }

    if (!headers_sent()) {
        header('HTTP/1.0 500 Internal Server Error');
    }
    $title='500 Internal Server Error';
    require_once __DIR__.'/header.inc';

    $fullUrl=$_SERVER['REQUEST_URI'] ?? 'not found'.'?'.$_SERVER['QUERY_STRING'] ?? 'none';
    error_log('500: '.$fullUrl.' Error: '.$num.' '.$message.' file '.$file.' line '.$line.' Referral :'.($_SERVER['HTTP_REFERER'] ?? 'none'));

    $briefError= [
        'errorType'=>'500',
        'dateStamp'=>date('c'),
        'url'=>$_SERVER['REQUEST_URI'] ?? 'not found',
        'query'=>$_SERVER['QUERY_STRING'] ?? 'none',
        'host'=>$_SERVER['HTTP_HOST'] ?? 'not found',
        'server'=>$_SERVER['SERVER_NAME'] ?? 'not found',
        'serverPort'=>$_SERVER['SERVER_PORT'] ?? 'not found',
        'method'=>$_SERVER['REQUEST_METHOD'] ?? 'not found',
        'debug'=>print_r(debug_backtrace(),true)
    ];
    $fullError=array_merge($briefError,
        [
            'userIp'=>$_SERVER['REMOTE_ADDR'] ?? 'none',
            'userAgent'=>$_SERVER['HTTP_USER_AGENT'] ?? 'none',
            'userReferer'=>$_SERVER['HTTP_REFERER'] ?? 'none',
            'userClientIp'=>$_SERVER['HTTP_CLIENT_IP'] ?? 'none',
            'userXForwardedFor'=>$_SERVER['HTTP_X_FORWARDED_FOR'] ?? 'none',
            'userCfConnectingIp'=>$_SERVER['HTTP_CF_CONNECTING_IP'] ?? 'none',
            'userCfRay'=>$_SERVER['HTTP_CF_RAY'] ?? 'none'
        ]
    );
    ?>

    <p>Sorry, the PublicWhip website encountered an error. It would be helpful if you could email <a href="mailto:team@publicwhip.org.uk">team@publicwhip.org.uk</a> with
        the following information:<br>
        If you don't mind us knowing your IP address, and web browser (which may help us diagnose issues and the information will only be used for this purpose),
        please send us the following information:<br>
    <pre>
        full:<?php echo chunk_split(base64_encode(json_encode($fullError)),80,'<br>'); ?>:end
    </pre><br>
    If, however, you would prefer to keep your IP address, web browser details, please send the following information:<br>
    <pre>
        brief:<?php echo chunk_split(base64_encode(json_encode($briefError)),80,'<br>'); ?>:end
    </pre><br>
    </p>
    <h2>What is in this diagnostic information?</h2>
    <p>It is a base64 encoded JSON array containing the error type you encountered,
        the date it occurred, the URL (including hostname and query string and the 'type' [GET or POST]) of the request,
        the name of the server that handled your request, the referral URL (which page you visited before hitting this error) and a 'stack trace'.</p>
    <p>If you choose to send us the full information, it also contains your IP address (and those of any proxy servers) and the user agent of your
        web browser which will only be used to assist us in diagnosing issues.</p>
<?php
    include __DIR__.'/footer.inc';
    return true;
}
set_error_handler('pw_handle_error');

function getmicrotime()
{
    list($usec, $sec) = explode(' ', microtime());
    return ((float)$usec + (float)$sec);
}

require_once __DIR__.'/pretty.inc';
require_once __DIR__.'/account/user.inc';
function pw_header() 
{
    global $second_links, $second_type;
    if (!$second_type) {
        $second_type = "";
        if ($second_links)
            $second_type = "default";
    }
    include __DIR__.'/header.inc';
}
function pw_header_notitle()
{
    global $second_links, $second_type;
    if (!$second_type) {
        $second_type = '';
        if ($second_links)
            $second_type = "default";
    }
    include __DIR__.'/header.inc';
}

function pw_footer() 
{
    include __DIR__.'/footer.inc';
}

/* get_http_var NAME [DEFAULTorALLOW]
 * Return the value of the GET or POST parameter with the given NAME; or, if no
 * such parameter is present, DEFAULT; or, if DEFAULT is not specified or is a
 * boolean, the empty string ("").
 * If DEFAULT is a boolean, allow the input to be changed (currently, only
 * for Esperanto input to take .x to various accented characters). It's thus
 * currently impossible to have a default and have changed input, but nowhere
 * on the PledgeBank site requires a default anyway.
 */
function get_http_var($name, $default='') {
    global $lang;

    if (is_bool($default)) {
        $allow_changes = true;
        $default = '';
    } else {
        $allow_changes = false;
    }

    if (array_key_exists($name, $_GET)) {
        $var = $_GET[$name];
        if (!is_array($var)) $var = trim($var);
    } elseif (array_key_exists($name, $_POST)) {
        $var = $_POST[$name];
        if (!is_array($var)) $var = trim($var);
    } else { 
        $var = $default;
    }
    if ($allow_changes && $lang == 'eo')
        $var = input_esperanto($var);
    return $var;
}

