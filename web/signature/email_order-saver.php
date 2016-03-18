<?php
session_start();
$body = @file_get_contents('php://input');
require 'PHPMailer-master/PHPMailerAutoload.php';

$myFile = 'orderbackup/' . $_SESSION['name'] . 'txt';
$fh = fopen($myFile, 'w') or die("can't open file");
$stringData = $body;
fwrite($fh, $stringData);
fclose($fh);
?>

//php_mailer
<?php
//Create a new PHPMailer instance
$mail = new PHPMailer;
// Set PHPMailer to use the sendmail transport
$mail->isSendmail();
//Set who the message is to be sent from
$mail->setFrom('sales@lashbrookdesigns.com', 'Sales');
//Set an alternative reply-to address
$mail->addReplyTo('sales@lashbrookdesigns.com', 'Sales');
//Set who the message is to be sent to
$mail->addAddress('cdnielson@folkprophet.com', 'Charles Nielson');
$mailer->AddAddress('bdnielson@folkprophet.com', 'Bryony Nielson');
//Set the subject line
$mail->Subject = 'Lashbrook Sales Order';
//Read an HTML message body from an external file, convert referenced images to embedded,
//convert HTML into a basic plain-text alternative body
$mail->msgHTML($body);
//Replace the plain text body with one created manually
$mail->AltBody = $body;
//Attach an image file
$mail->addAttachment('signatures/' . $_SESSION['name']);
$mail->AddEmbeddedImage('signatures/' . $_SESSION['name'], 'my-photo', 'signatures/' . $_SESSION['name']);
$mail->Body = $body . 'Embedded Image: <img alt="PHPMailer" src="cid:my-photo">';

//send the message, check for errors
if (!$mail->send()) {
    echo "Mailer Error: " . $mail->ErrorInfo;
} else {
    echo "Message sent!";
}
?>
