<?php
session_start();

$body = @file_get_contents('php://input');

$result = json_decode($body);

$_SESSION['data'] = addslashes($result->lastName);

echo "lastname.php - Session String is loaded with the data:" . $_SESSION['data'];

?>
