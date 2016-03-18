<?php
$con = mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");

$body = @file_get_contents('php://input');
// Check connection
if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$result = json_decode($body);

$clientresult = mysqli_query($con, "SELECT * FROM clients_new");
$clientArray = array();

while($row = mysqli_fetch_array($clientresult)) {
    array_push($clientArray, array(
        'client_idx' => $row['client_idx'],
        'store_name' => $row['store_name'],
        'last_name' => $row['last_name'],
        'first_name' => $row['first_name'],
        'address' => $row['address'],
        'city' => $row['city'],
        'state' => $row['state'],
        'zip' => $row['zip'],
        'country' => $row['country'],
        'phone' => $row['phone'],
        'fax' => $row['fax'],
        'email' => $row['email']));
}

/*$dataToSendArray = array();

foreach($clientArray as $c) {
    $temp = stripos($c['store_name'], $result);
    if ($temp === false) {


    } else {
        array_push($dataToSendArray, $c);
    }
}*/

$send = json_encode($clientArray);

echo $send;

?>