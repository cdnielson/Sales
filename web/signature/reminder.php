<?php
require 'PHPMailer-master/PHPMailerAutoload.php';
$body = @file_get_contents('php://input');

$result = json_decode($body);

$repEmail = addslashes($result->repEmail);
$firstName = addslashes($result->firstName);
$lastName = addslashes($result->lastName);
$storeName = addslashes($result->storeName);

$emailBody = "This is a reminder email that you have created an order for " . $firstName . " " . $lastName . " for the store " . $storeName . ". This email is automatically generated when you complete an order prior to it being signed. If you have gathered the signature, you may disregard this email.";

$mail = new PHPMailer;
$mail->isSendmail();
$mail->setFrom('sales@lashbrookdesigns.com', 'Sales');
$mail->addReplyTo('sales@lashbrookdesigns.com', 'Sales');
$mail->addAddress($repEmail);
$mail->Subject = 'Reminder - Lashbrook Sales Order';
$mail->msgHTML($emailBody);
$mail->AltBody = $emailBody;

if (!$mail->send()) {
    echo "Mailer Error: " . $mail->ErrorInfo;
} else {
    echo "Message sent!</div></body>";
}

?>