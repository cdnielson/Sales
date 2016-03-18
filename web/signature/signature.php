<?php
require_once 'signature_to_image/signature-to-image.php';

$json = $_POST['output'];
//$idx = $_POST['id'];
$id = $_POST['id'];


//echo "The data sent to signature.php is " . $_SESSION['data'];
//$img2 = sigJsonToImage($json);
$img = sigJsonToImage($json, array('imageSize'=>array(800, 200)));

$con=mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");

if (mysqli_connect_errno()) {
    //  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
$order_idx = $id;

$sql="INSERT INTO signatures (order_idx, sig_json)
    VALUES ('$order_idx', '$json')";

if ($con->query($sql) === TRUE) {
    // echo "Record updated successfully.";
} else {
    echo "Error: " . $sql . "<br>" . $con->error;
}

//save to file
//imagepng($img, 'signatures/signature_' . $name . '.png');
imagepng($img, 'signatures/' . $id . '.png');
//output to browser
//$con=mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");


if (mysqli_connect_errno()) {
    //  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$order_mst = mysqli_query($con, "SELECT * FROM order_mst WHERE order_idx = ('$id')");

$order_array = array();

//pushes to postion [0] of the array
while($row = mysqli_fetch_array($order_mst)) {
    array_push($order_array, array(
        'order_idx' => $row['order_idx'],
        'order_name' => $row['order_name'],
        'client_idx' => $row['client_idx'],
        'completed' => $row['completed'],
        'tier' => $row['tier'],
        'rep' => $row['rep'],
        'date' => $row['order_date'],
        'emailed' => $row['emailed']));
}

if ($order_array[0]['tier'] == 0) {
    $tier = "No Tier";
}
if ($order_array[0]['tier'] == 1) {
    $tier = "Tier One";
}
if ($order_array[0]['tier'] == 2) {
    $tier = "Tier Two";
}
if ($order_array[0]['tier'] == 3) {
    $tier = "Tier Three";
}
if ($order_array[0]['tier'] == 4) {
    $tier = "Tier Four";
}
if ($order_array[0]['tier'] == 5) {
    $tier = "Tier Four Guaranteed";
}

$client = $order_array[0]["client_idx"];

$client_mst = mysqli_query($con, "SELECT * FROM clients_new WHERE client_idx = ('$client')");

//pushes to position [1] of the array
while($row = mysqli_fetch_array($client_mst)) {
    array_push($order_array, array(
        'store_name' => $row['store_name'],
        'last_name' => $row['last_name'],
        'first_name' => $row['first_name'],
        'address' => $row['address'],
        'city' => $row['city'],
        'state' => $row['state'],
        'zip' => $row['zip'],
        'phone' => $row['phone'],
        'email' => $row['email']));
}

$email = $order_array[1]["email"];

$order_data = mysqli_query($con, "SELECT * FROM order_data WHERE order_idx = ('$id')");

//pushes to position [2] of the array
while($row = mysqli_fetch_array($order_data)) {
    array_push($order_array, array(
        'terms' => $row['terms'],
        'notes' => $row['notes']));
}

$rings_added = mysqli_query($con, "SELECT * FROM rings_added WHERE order_idx = ('$id')");

$added_array = array();

while($row = mysqli_fetch_array($rings_added)) {
    array_push($added_array, array(
        'sku' => $row['sku'],
        'finish' => $row['finish'],
        'notes' => $row['notes']));
}

$rings_removed = mysqli_query($con, "SELECT * FROM rings_removed WHERE order_idx = ('$id')");

$removed_array = array();

while($row = mysqli_fetch_array($rings_removed)) {
    array_push($removed_array, array(
        'sku' => $row['sku'],
        'finish' => $row['finish']));
}

$accessories = mysqli_query($con, "SELECT * FROM accessories WHERE order_idx = ('$id')");

$accessories_array = array();

while($row = mysqli_fetch_array($accessories)) {
    array_push($accessories_array, array(
        'sku' => $row['sku'],
        'finish' => $row['finish'],
        'notes' => $row['notes']));
}

$custom = mysqli_query($con, "SELECT * FROM rings_custom WHERE order_idx = ('$id')");

$custom_array = array();

while($row = mysqli_fetch_array($custom)) {
    array_push($custom_array, array(
        'sku' => $row['sku'],
        'finish' => $row['finish'],
        'price' => $row['price']));
}

$sb = mysqli_query($con, "SELECT * FROM stockbalances WHERE order_idx = ('$id')");

$sb_array = array();

while($row = mysqli_fetch_array($sb)) {
    array_push($sb_array, array(
        'sku' => $row['id'],
        'price' => $row['price']));
}

$subtotal = 0;

$dc = mysqli_query($con, "SELECT * FROM custom_display WHERE order_idx = ('$id')");

$dc_array = array();

while($row = mysqli_fetch_array($dc)) {
    array_push($dc_array, array(
        'acrylic' => $row['acrylic'],
        'top' => $row['top'],
        'side' => $row['side']));
}
$acrylic = $dc_array[0]["acrylic"];
$top = $dc_array[0]["top"];
$side = $dc_array[0]["side"];

$body = '<style>
    body {
        background: white;
        color: black;
    }
    #order {
        border-top: 1px dotted black;
        border-right: 1px dotted black;
        background: white;
        margin-left: 20px;
        margin-right: 20px;
        width: 95%;
    }
    .field {
        border-bottom: 1px dotted black;
        border-left: 1px dotted black;
        padding-left: 5px;
    }
    .subfield {
        border-bottom: 1px dotted black;
        border-left: 1px dotted black;
        width: 75px;
        text-align: end;
        padding-right: 30px;
    }
    .header {
        font-weight: bold;
    }
    .signaturecontainer {
        margin-left: 20px;
        margin-right: 20px;
        width: 95%;
        background: white;
        border: none;
</style>';

$body .= '<body>

<div style="text-align: center; width: 100%;">THANK YOU FOR YOUR ORDER.</div>';

$body .= '<table id="order">';
$body .= '<tr><td class="field">Order ID: ' . $order_array[0]["order_idx"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Date: ' . $order_array[0]["date"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Order Name: ' . $order_array[0]["order_name"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Rep: ' . $order_array[0]["rep"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Store Name: ' . $order_array[1]["store_name"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">First Name: ' . $order_array[1]["first_name"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Last Name: ' . $order_array[1]["last_name"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Address: ' . $order_array[1]["address"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">City: ' . $order_array[1]["city"] .  '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">State: ' . $order_array[1]["state"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Zip: ' . $order_array[1]["zip"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Phone: ' . $order_array[1]["phone"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Email: ' . $order_array[1]["email"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Terms: ' . $order_array[2]["terms"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">Notes: ' . $order_array[2]["notes"] . '</td><td style="background: #d3d3d3;"></td></tr>';
$body .= '<tr><td class="field">' . $tier . '</td><td style="background: #d3d3d3;"></td></tr>';

$store = $order_array[1]["store_name"];

$con2 = mysqli_connect("","lbrook_app_rings","L@shbrook!","lbrook_app_rings");
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
$check = empty($added_array);
if ($check == false) {

    foreach ($added_array as $a) {
        $sku = $a['sku'];
        $finish = $a['finish'];
        $ring_data = mysqli_query($con2, "SELECT * FROM rings WHERE sku = ('$sku') AND finish = ('$finish')");
        while($row = mysqli_fetch_array($ring_data)) {
            if ($tier == "Tier One") {
                if ($row['tier'] == 1) {
                    $added .= "<tr><td class='field'>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</td><td class='subfield'>$" . $row['price'] . "</td></tr>";
                    $subtotal = $subtotal + $row['price'];
                }
                if ($row['tier'] != 1) {
                    $addedplus .= "<tr><td class='field'>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</td><td class='subfield'>$" . $row['price'] . "</td></tr>";
                    $subtotal = $subtotal + $row['price'];
                }
            }
            if ($tier == "Tier Two") {
                if ($row['tier'] == 1 || $row['tier'] == 2) {
                    $added .= "<tr><td class='field'>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</td><td class='subfield'>$" . $row['price'] . "</td></tr>";
                    $subtotal = $subtotal + $row['price'];
                }
                if ($row['tier'] == 3 || $row['tier'] == 4 || $row['tier'] == 5 || $row['tier'] == 0) {
                    $addedplus .= "<tr><td class='field'>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</td><td class='subfield'>$" . $row['price'] . "</td></tr>";
                    $subtotal = $subtotal + $row['price'];
                }
            }
            if ($tier == "Tier Three") {
                if ($row['tier'] == 1 || $row['tier'] == 2 || $row['tier'] == 3) {
                    $added .= "<tr><td class='field'>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</td><td class='subfield'>$" . $row['price'] . "</td></tr>";
                    $subtotal = $subtotal + $row['price'];
                }
                if ($row['tier'] == 4 || $row['tier'] == 5 || $row['tier'] == 0) {
                    $addedplus .= "<tr><td class='field'>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</td><td class='subfield'>$" . $row['price'] . "</td></tr>";
                    $subtotal = $subtotal + $row['price'];
                }
            }
            if ($tier == "Tier Four" || $tier == "Tier Four Guaranteed") {
                if ($row['tier'] == 1 || $row['tier'] == 2 || $row['tier'] == 3 || $row['tier'] == 4) {
                    $added .= "<tr><td class='field'>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</td><td class='subfield'>$" . $row['price'] . "</td></tr>";
                    $subtotal = $subtotal + $row['price'];
                }
                if ($row['tier'] == 0) {
                    $addedplus .= "<tr><td class='field'>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</td><td class='subfield'>$" . $row['price'] . "</td></tr>";
                    $subtotal = $subtotal + $row['price'];
                }
            }
            if ($tier == "No Tier") {
                $addedplus .= "<tr><td class='field'>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</td><td class='subfield'>$" . $row['price'] . "</td></tr>";
                $subtotal = $subtotal + $row['price'];
            }
        }
    }
}

$check = empty($added);
if ($check == false) {
    $body .= "<tr><td class='field header'>Rings in the Tier</td><td style='background: #d3d3d3;'></td></tr>";
    $body .= $added;
}

$con2 = mysqli_connect("","lbrook_app_rings","L@shbrook!","lbrook_app_rings");
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$con2 = mysqli_connect("","lbrook_app_rings","L@shbrook!","lbrook_app_rings");
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$check = empty($removed_array);
if ($check == false) {
    $body .= '<tr><td class="field header">With the following rings removed from the Tier:</td><td style="background: #d3d3d3;"></td></tr>';
    foreach ($removed_array as $a) {
        $sku = $a['sku'];
        $finish = $a['finish'];
        $ring_data = mysqli_query($con2, "SELECT * FROM rings WHERE sku = ('$sku') AND finish = ('$finish')");
        while($row = mysqli_fetch_array($ring_data)) {
            $body .= '<tr><td class="field">' . $row["sku"] . " - " . $row["finish"] . '</td><td style="background: #d3d3d3;"></td></tr>';
        }
    }
}

$check = empty($addedplus);
if ($check == false) {
    $body .= "<tr><td class='field header'>Added Rings</td><td style='background: #d3d3d3;'></td></tr>";
    $body .= $addedplus;
}

$check = empty($accessories_array);
if ($check == false) {
    $body .= '<tr><td class="field header">Other Items Added:</td><td style="background: #d3d3d3;"></td></tr>';
    foreach ($accessories_array as $a) {
        $sku = $a['sku'];
        $finish = $a['finish'];
        $accessories_data = mysqli_query($con2, "SELECT * FROM rings WHERE sku = ('$sku') AND finish = ('$finish')");
        while ($row = mysqli_fetch_array($accessories_data)) {
            $body .= '<tr><td class="field">' . $row["sku"] . ' - ' . $row["finish"] . " - " . $a['notes'] . '</td><td class="subfield">$' . $row["price"] . '</td></tr>';
            $subtotal = $subtotal + $row['price'];
        }
    }
}

$check = empty($dc_array);
if ($check == false) {
    $body .=  '<tr><td class="field header">Custom Display Colors</td><td class="subfield" style="background: #d3d3d3;"></td></tr>';
    $body .= '<tr><td class="field">Acrylic top: ' . $acrylic . '</td><td class="subfield" style="background: #d3d3d3;"></td></tr>';
    $body .= '<tr><td class="field">Top: ' . $top . '</td><td class="subfield" style="background: #d3d3d3;"></td></tr>';
    $body .= '<tr><td class="field">Side: '. $side . '</td><td class="subfield" style="background: #d3d3d3;"></td></tr>';
}

$check = empty($custom_array);
if ($check == false) {
    $body .= '<tr><td class="field header">Custom Skus:</td><td style="background: #d3d3d3;"></td></tr>';
    foreach ($custom_array as $a) {
        $body .= '<tr><td class="field">' . $a["sku"] . ' - ' . $a["finish"] . '</td><td class="subfield">$' . $a["price"] . '</td></tr>';
        $subtotal = $subtotal + $a['price'];
    }
}

$check = empty($sb_array);
if ($check == false) {
    $body .= '<tr><td class="field header">Stock Balances:</td><td style="background: #d3d3d3;"></td></tr>';
    foreach ($sb_array as $a) {
        $body .= '<tr><td class="field">' . $a["id"] . '</td><td class="subfield">$' . $a["price"] . '</td></tr>';
        $subtotal = $subtotal + $a['price'];
    }
}

$body .= '<tr><td class="field header">Subtotal:</td><td class="subfield">$' . $subtotal . '</td></tr>';

$shipping = 0;
if ($subtotal < 3001) {
    $shipping = 20;
}
if ($subtotal > 3000 && $subtotal < 6001) {
    $shipping = 35;
}
if ($subtotal > 6000 && $subtotal < 10001) {
    $shipping = 50;
}
if ($subtotal > 10000) {
    $shipping = 75;
}

$body .= '<tr><td class="field">Shipping Costs:</td><td class="subfield">$' . $shipping . '</td></tr>';

$total = $subtotal + $shipping;

$body .= '<tr style="font-size: large"><td class="field header">Total:</td><td class="subfield">$' . $total . '</td></tr></table>';

echo '<div><img src="../images/lb_logo.jpg"></div>';

echo $body;

?>

    <iframe class="signaturecontainer" src="signaturedownload.php?id=<? echo $id ?>" seamless="true" height="300px"></iframe>

<?php

    //session_start();
    require 'PHPMailer-master/PHPMailerAutoload.php';

    //$tempbody = $result->body;
    //$lastName = $result->lastName;
    //$email = $result->email;
    //$repEmail = $result->repEmail;
    //$orderID = $result->orderID;
    //$randnumber = rand();

    //$body = "<p>Order Id: " . $orderID . "</p>" . $tempbody;

    /*if ($lastName == "temp") {
        rename('signatures/signature_.png', 'signatures/signature_' . $randnumber . '.png');
    }*/

    $myFile = 'orderbackup/' . $id . '.html';
    $fh = fopen($myFile, 'w') or die("can't open file");
    fwrite($fh, $body);
    $filename =  '<br><img src="../signatures/' . $id . '.png">';
    fwrite($fh, $filename);
    fclose($fh);
?>

<?
$rep = $order_array[0]['rep'];
$order_rep = mysqli_query($con, "SELECT * FROM reps WHERE username = ('$rep')");
$repEmail = "";
while($row = mysqli_fetch_array($order_rep)) {
    $repEmail = $row['email'];
}

?>

    //php_mailer
<?php

    $emailList = array(

        'taylor@lashbrookdesigns.com',
        'eric@lashbrookdesigns.com',
        'travis@lashbrookdesigns.com',
        'megan@lashbrookdesigns.com',
        'charles@lashbrookdesigns.com',
        $repEmail,
        $email
    );
/*
    //Create a new PHPMailer instance
    $mail = new PHPMailer;
    // Set PHPMailer to use the sendmail transport
    $mail->isSendmail();
    //Set who the message is to be sent from
    $mail->setFrom('sales@lashbrookdesigns.com', 'Sales');
    //Set an alternative reply-to address
    $mail->addReplyTo('sales@lashbrookdesings.com', 'Sales');
    //Set who the message is to be sent to
    //$mail->addAddress($repEmail);
    foreach ($emailList as $e) {
        $mail->addAddress($e);
    }
    //Set the subject line
    $mail->Subject = 'TEST Lashbrook Sales Order for ' . $store;
    //Read an HTML message body from an external file, convert referenced images to embedded,
    //convert HTML into a basic plain-text alternative body
    $mail->msgHTML($body);
    //Replace the plain text body with one created manually
    $mail->AltBody = $body;
    //Attach an image file
    //$mail->addAttachment('signatures/signature_' . $_SESSION['data']);

    $mail->AddEmbeddedImage('signatures/' . $id . '.png', 'my-sig', 'signatures/' . $id . '.png');
    $mail->AddEmbeddedImage("../images/lb_logo.jpg", 'my-logo', "../images/lb_logo.jpg");

    $mail->Body = '<img alt="PHPMailer" src="cid:my-logo"><div style="background: white;">' . $body . '<img alt="PHPMailer" src="cid:my-sig"></div>';

    //send the message, check for errors
    if (!$mail->send()) {
        echo "Mailer Error: " . $mail->ErrorInfo;
    } else {
        echo "Message sent!</div></body>";
    }*/




date_default_timezone_set('Etc/UTC');

$mail = new PHPMailer;
$mail->isSMTP();
//$mail->SMTPDebug = 2;
//$mail->Debugoutput = 'html';

//$mail->SMTPSecure = 'tls';
$mail->Host = "relay.appriver.com";
$mail->Port = 2525;
$mail->SMTPAuth = false;
//$mail->Username = "charles@lashbrookdesigns.com";
//$mail->Password = "Bryony3#";
$mail->setFrom('sales@lashbrookdesigns.com', 'Sales');
$mail->addReplyTo('sales@lashbrookdesigns.com', 'Sales');
foreach ($emailList as $e) {
    $mail->addAddress($e);
}
//Set the subject line
$mail->Subject = 'TEST Lashbrook Sales Order for ' . $store;
//Read an HTML message body from an external file, convert referenced images to embedded,
//convert HTML into a basic plain-text alternative body
$mail->msgHTML($body);
//Replace the plain text body with one created manually
$mail->AltBody = $body;
//Attach an image file
//$mail->addAttachment('signatures/signature_' . $_SESSION['data']);

$mail->AddEmbeddedImage('signatures/' . $id . '.png', 'my-sig', 'signatures/' . $id . '.png');
$mail->AddEmbeddedImage("../images/lb_logo.jpg", 'my-logo', "../images/lb_logo.jpg");

$mail->Body = '<img alt="PHPMailer" src="cid:my-logo"><div style="background: white;">' . $body . '<img alt="PHPMailer" src="cid:my-sig"></div>';

//send the message, check for errors
if ($order_array[0]['emailed'] == 0) {
    if (!$mail->send()) {
        echo "Mailer Has Error: " . $mail->ErrorInfo;
    } else {

        $sql="UPDATE order_mst SET emailed=1 WHERE order_idx = ('$id')";

        if ($con->query($sql) === TRUE) {
            // echo "Record updated successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }



        echo "Message sent!</div></body>";
    }
} else {
    echo "Email already sent.";
}

?>