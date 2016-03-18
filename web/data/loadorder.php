<?php
$con = mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");

$body = @file_get_contents('php://input');
// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

session_start();

$send = json_encode($_SESSION["order_idx"]);

echo $send;

//$result = json_decode($body);


//$resultOrderMst = mysqli_query($con,"SELECT * FROM order_mst WHERE order_name = ('$order_idx')");
//$orderMasterArray = array();

//while($row = mysqli_fetch_array($resultOrderMst)) {
//    array_push($orderMasterArray, array(
//        'order_idx' => $row['order_idx'],
//        'order_name' => $row['order_name'],
//        'client_idx' => $row['client_idx'],
//        'tier' => $row['tier'],
//        'grtd_flg' => $row['grtd_flg']));
//}
//
//$getData = $orderMasterArray["order_idx"];
//
//echo $getData;

/*


$resultRingsRemoved = mysqli_query($con,"SELECT * FROM rings_removed WHERE order_idx = ('$getData')");

$ringsRemovedArray = array();
while($row = mysqli_fetch_array($resultRingsRemoved)) {
    array_push($ringsRemovedArray, array(
        'sku' => $row['sku'],
        'finish' => $row['finish']));
}
mysqli_close($con);

$send = json_encode($ringsRemovedArray);

echo $getData;*/
//echo $send;

?>