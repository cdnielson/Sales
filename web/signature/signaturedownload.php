<?php
require_once 'signature_to_image/signature-to-image.php';

$con=mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");
$id = $_GET['id'];

if (mysqli_connect_errno()) {
    //  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$result = mysqli_query($con, "SELECT * FROM signatures WHERE order_idx = ('$id')");

$resultArray = array();


    while($row = mysqli_fetch_array($result)) {
        array_push($resultArray, array(
            'json' => $row['sig_json']));
    }

$jsonresult = $resultArray[0]["json"];

//var_dump($json);
$json = json_decode($jsonresult);
//save to file
$img = sigJsonToImage($json, array('imageSize'=>array(800, 200)));
//imagepng($img, 'signatures/' . $id . '.png');

//output to browser
header('Content-Type: image/png');
imagepng($img);

//destroys image in memory
imagedestroy($img);

?>
