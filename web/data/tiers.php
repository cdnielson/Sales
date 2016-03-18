<?php
$con = mysqli_connect("","lbrook_app_rings","L@shbrook!","lbrook_app_rings");
            if (mysqli_connect_errno()) {
                echo "Failed to connect to MySQL: " . mysqli_connect_error();
            }

$rings = mysqli_query($con, "SELECT * FROM rings");
$ringsArray = array();

while($row = mysqli_fetch_array($rings)) {
    array_push($ringsArray, array(
        'id' => $row['id'],
        'category' => $row['category'],
        'SKU' => $row['sku'],
        'finish' => $row['finish'],
        'price' => $row['price'],
        'tier' => $row['tier'],
        'image' => $row['image'],
        'combo' => $row['combo'],
        'combo2' => $row['combo2']));
}

$send = json_encode($ringsArray);

echo $send;

?>