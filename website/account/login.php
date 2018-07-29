<?php
require_once __DIR__."/../common.inc";

require_once __DIR__."/../database.inc";
require_once __DIR__"/user.inc";

if (!$adminAllowed) {
    pw_handle_404('Not authorised','IP Address does not match');
    die();
}
$just_logged_in = do_login_screen();
if (!user_isloggedin()) {
    login_screen();
    exit;
} else {
    header('Location: /account/settings.php');
}