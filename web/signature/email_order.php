<?php
session_start();
require 'PHPMailer-master/PHPMailerAutoload.php';

$data = @file_get_contents('php://input');
$result = json_decode($data);

$tempbody = $result->body;
$lastName = $result->lastName;
$email = $result->email;
$repEmail = $result->repEmail;
$orderID = $result->orderID;
$randnumber = rand();

$body = "<p>Order Id: " . $orderID . "</p>" . $tempbody;

if ($lastName == "temp") {
	rename('signatures/signature_.png', 'signatures/signature_' . $randnumber . '.png');
}

$myFile = 'orderbackup/' . $lastName . '.html';
$fh = fopen($myFile, 'w') or die("can't open file");
$btn ='<a href="http://www.lashbrookdesigns.com/sales">Click here to place a new order</a><br><br>';
fwrite($fh, $btn);
fwrite($fh, $body);
$filename =  '<br><img src="../signatures/signature_' . $lastName . '.png">';
if ($lastName == "temp") {
	$filename =  '<br><img src="../signatures/signature_" . $randnumber . ".png">';
}
fwrite($fh, $filename);
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
$mail->addReplyTo('sales@lashbrookdesings.com', 'Sales');
//Set who the message is to be sent to
$mail->addAddress($repEmail);
$mail->addAddress($email);
//$mail->addAddress('cadie@lashbrookdesigns.com');
//$mail->addAddress('eric@lashbrookdesigns.com');
//$mail->addAddress('megan@lashbrookdesigns.com');
//$mail->addAddress('bryony@lashbrookdesigns.com', 'Bryony Nielson');
//$mail->addAddress('charles@lashbrookdesigns.com', 'Charles Nielson');
//Set the subject line
$mail->Subject = 'TEST Lashbrook Sales Order';
//Read an HTML message body from an external file, convert referenced images to embedded,
//convert HTML into a basic plain-text alternative body
$mail->msgHTML($body);
//Replace the plain text body with one created manually
$mail->AltBody = $body;
//Attach an image file
//$mail->addAttachment('signatures/signature_' . $_SESSION['data']);

if ($lastName == "temp") {
	$mail->AddEmbeddedImage('signatures/signature_' . $randnumber . '.png', 'my-photo', 'signatures/signature_' . $randnumber . '.png');
} else {
	$mail->AddEmbeddedImage('signatures/signature_' . $lastName . '.png', 'my-photo', 'signatures/signature_' . $lastName . '.png');
}
$mail->Body = $body . '<img alt="PHPMailer" src="cid:my-photo">';

//send the message, check for errors
if (!$mail->send()) {
    echo "Mailer Error: " . $mail->ErrorInfo;
} else {
    echo "Message sent!";
	if ($lastName == "temp") {
		$file = 'orderbackup/temp.html';
		$newfile = 'orderbackup/' . $randnumber . '.html';

		if (!copy($file, $newfile)) {
    			echo "failed to copy $file...\n";
		}


	}
}
?>
