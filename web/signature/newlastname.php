<?php
session_start();

$body = @file_get_contents('php://input');

$_SESSION['otherdata'] = $body;

echo "otherlastname.php - Session String is loaded with the data:" . $_SESSION['otherdata'];

?>