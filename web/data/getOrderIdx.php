<?php
$con = mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");
session_start();
$body = @file_get_contents('php://input');
// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}


$tempresult = json_decode($body);
$result = addslashes($tempresult);

$idxresult = mysqli_query($con, "SELECT * FROM order_mst WHERE order_idx = ('$result')");
$orderIDXArray = array();

while($row = mysqli_fetch_array($idxresult)) {
    array_push($orderIDXArray, array(
        'order_idx' => $row['order_idx'],
        'tier' => $row['tier'],
        'client_idx' => $row['client_idx']));
}

foreach($orderIDXArray as $o) {
    $order_idx = $o["order_idx"];
    $client_idx = $o["client_idx"];
}

$customerInfo = mysqli_query($con, "SELECT * FROM clients_new WHERE client_idx = ('$client_idx')");
if (!$customerInfo) {
    printf("Error: %s\n", mysqli_error($con));
    exit();
}
$customerInfoArray = array();

while($row = mysqli_fetch_array($customerInfo)) {
    array_push($customerInfoArray, array(
        'checked' => $row['checked'],
        'storeName' => $row['store_name'],
        'lastName' => $row['last_name'],
        'firstName' => $row['first_name'],
        'address' => $row['address'],
        'city' => $row['city'],
        'state' => $row['state'],
        'zip' => $row['zip'],
        'phone' => $row['phone'],
        'email' => $row['email'],
        'terms' => $row['terms'],
        'notes' => $row['notes']));
}

$orderRemoved = mysqli_query($con, "SELECT * FROM rings_removed WHERE order_idx = ('$order_idx')");

$orderRemovedArray = array();

while($row = mysqli_fetch_array($orderRemoved)) {
    array_push($orderRemovedArray, array(
        'SKU' => $row['sku'],
        'finish' => $row['finish']));
}

$orderAdded = mysqli_query($con, "SELECT * FROM rings_added WHERE order_idx = ('$order_idx')");

$orderAddedArray = array();

while($row = mysqli_fetch_array($orderAdded)) {
    array_push($orderAddedArray, array(
        'SKU' => $row['sku'],
        'finish' => $row['finish'],
        'notes' => $row['notes']));
}

$orderAccessories = mysqli_query($con, "SELECT * FROM accessories WHERE order_idx = ('$order_idx')");

$orderAccessoriesArray = array();

while($row = mysqli_fetch_array($orderAccessories)) {
    array_push($orderAccessoriesArray, array(
        'SKU' => $row['sku'],
        'finish' => $row['finish'],
        'notes' => $row['notes']));
}

$orderCustom = mysqli_query($con, "SELECT * FROM rings_custom WHERE order_idx = ('$order_idx')");

$orderCustomArray = array();

while($row = mysqli_fetch_array($orderCustom)) {
    array_push($orderCustomArray, array(
        'sku' => $row['sku'],
        'finish' => $row['finish'],
        'price' => $row['price']));
}

$orderSB = mysqli_query($con, "SELECT * FROM stockbalances WHERE order_idx = ('$order_idx')");

$orderSBArray = array();

while($row = mysqli_fetch_array($orderSB)) {
    array_push($orderSBArray, array(
        'id' => $row['id'],
        'price' => $row['price']));
}

$orderData = mysqli_query($con, "SELECT * FROM order_data WHERE order_idx = ('$order_idx')");

$orderDataArray = array();

while($row = mysqli_fetch_array($orderData)) {
    array_push($orderDataArray, array(
        'terms' => $row['terms'],
        'notes' => $row['notes']));
}

$completeOrderArray = array(
    "customer" => $customerInfoArray,
    "master" => $orderIDXArray,
    "removed" => $orderRemovedArray,
    "added" => $orderAddedArray,
    "accessories" => $orderAccessoriesArray,
    "custom" => $orderCustomArray,
    "stockbalances" => $orderSBArray,
    "orderdata" => $orderDataArray
);

$send = json_encode($completeOrderArray);

echo $send;

//while($row = mysqli_fetch_array($resultOrderMst)) {
//    array_push($orderMasterArray, array(
//        'order_idx' => $row['order_idx'],
//        'order_name' => $row['order_name'],
//        'client_idx' => $row['client_idx'],
//        'tier' => $row['tier'],
//        'grtd_flg' => $row['grtd_flg']));
//}

//$getData = $orderMasterArray["order_idx"];

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