<?php
$con = mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");

// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}



$resultAll = mysqli_query($con,"SELECT * FROM order_mst WHERE new = 1");


$arrAll = array();




while($row = mysqli_fetch_array($resultAll)) {
    array_push($arrAll, array(
        'order_idx' => $row['order_idx'],
        'order_name' => $row['order_name'],
        'client_idx' => $row['client_idx'],
        'tier' => $row['tier'],
        'grtd_flg' => $row['grtd_flg'],
        'completed' => $row['completed']));
}

$send = json_encode($arrAll);

echo $send;

?>


