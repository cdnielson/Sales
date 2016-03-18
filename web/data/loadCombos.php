<?php
$con=mysqli_connect("","lbrook_app_rings","L@shbrook!","lbrook_app_rings");

// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}



$resultAll = mysqli_query($con,"SELECT * FROM combos");


//can I just send $resultAll as a json_encode?? Try later.
$arrAll = array();

while($row = mysqli_fetch_array($resultAll)) {
    array_push($arrAll, array(
        'sku' => $row['sku'],
        'finish' => $row['finish'],
        'combo' => $row['combo']));
}

$send = json_encode($arrAll);

echo $send;

?>


