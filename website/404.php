<?php
declare(strict_types=1);
// if we were accessed directly, bounce to index page.
if (!isset($_SERVER['REDIRECT_URL']) && !isset($_GET['error'])) {
    header('Location: /?error=notAvailable');
    exit;
}
$ignores=['/wp-login.php','/apple-touch-icon.png','/apple-touch-icon-precomposed.png','/ads.txt'];
if (\in_array($_SERVER['REDIRECT_URL'] ?? '',$ignores,TRUE)) {
    header('Location: /?error=invalidPage');
    exit;
}
include __DIR__.'/common.inc';
pw_handle_404('404 Not Found','Sorry, the page you are looking for has not been found.');
die();