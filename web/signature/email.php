<?php
session_start();

$body = @file_get_contents('php://input');

$result = json_decode($body);

$_SESSION['email'] = addslashes($result->email);
$_SESSION['repEmail'] = addslashes($result->repEmail);

echo "email.php the session string email is: " . $_SESSION['email'] . " and the session string repEmail is: " . $_SESSION['repEmail'];
?>
