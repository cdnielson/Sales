<?php
$con=mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");
$body = @file_get_contents('php://input');
// Check connection
if (mysqli_connect_errno()) {
    //  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// escape variables for security
$result = json_decode($body);


$tempCustomerInfo = array($result->customer_info);
$tempOrderData = array($result->order_data);
$customerInfo = objectToArray($tempCustomerInfo);
$orderData = objectToArray($tempOrderData);

$client_idx = addslashes($customerInfo[0]["client_idx"]);
$checked = addslashes($customerInfo[0]["checked"]);
$storeName = addslashes($customerInfo[0]["storeName"]);
$lastName = addslashes($customerInfo[0]["lastName"]);
$firstName = addslashes($customerInfo[0]["firstName"]);
$address = addslashes($customerInfo[0]["address"]);
$city = addslashes($customerInfo[0]["city"]);
$state = addslashes($customerInfo[0]["state"]);
$zip = addslashes($customerInfo[0]["zip"]);
$phone = addslashes($customerInfo[0]["phone"]);
$email = addslashes($customerInfo[0]["email"]);
$new = $result->new;

$display = array($result->display);
$displayInfo = objectToArray($display);

$top = addslashes($displayInfo[0]["top"]);

$side = addslashes($displayInfo[0]["side"]);
$acrylic = addslashes($displayInfo[0]["acrylic"]);



if ($client_idx == "none") {
    $sql="INSERT INTO clients_new (checked, store_name, last_name, first_name, address, city, state, zip, phone, email)
    VALUES ('$checked', '$storeName', '$lastName', '$firstName', '$address', '$city', '$state', '$zip', '$phone', '$email')";

    if ($con->query($sql) === TRUE) {
        $client_idx = $con->insert_id;
        //  echo "New record created successfully. Last inserted ID is: " . $client_idx;

    } else {
        //  echo "Error: " . $sql . "<br>" . $con->error;
    }
} else {
    $clientData = mysqli_query($con, "SELECT * FROM clients_new WHERE client_idx = ('$client_idx')");

    $clientDataArray = array();

    while($row = mysqli_fetch_array($clientData)) {
        array_push($clientDataArray, array(
            'last_name' => $row['last_name'],
            'first_name' => $row['first_name'],
            'address' => $row['address'],
            'city' => $row['city'],
            'state' => $row['state'],
            'zip' => $row['zip'],
            'phone' => $row['phone'],
            'email' => $row['email']));
    }

    if ($lastName != $clientDataArray["last_name"]) {
        $sql="UPDATE clients_new SET last_name=('$lastName') WHERE client_idx=('$client_idx')";
        if ($con->query($sql) === TRUE) {
              // echo "Record updated successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }
    }
    if ($firstName != $clientDataArray["first_name"]) {
        $sql="UPDATE clients_new SET first_name=('$firstName') WHERE client_idx=('$client_idx')";
        if ($con->query($sql) === TRUE) {
            // echo "Record updated successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }
    }
    if ($address != $clientDataArray["address"]) {
        $sql="UPDATE clients_new SET address=('$address') WHERE client_idx=('$client_idx')";
        if ($con->query($sql) === TRUE) {
            // echo "Record updated successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }
    }
    if ($city != $clientDataArray["city"]) {
        $sql="UPDATE clients_new SET city=('$city') WHERE client_idx=('$client_idx')";
        if ($con->query($sql) === TRUE) {
            // echo "Record updated successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }
    }
    if ($state != $clientDataArray["state"]) {
        $sql="UPDATE clients_new SET state=('$state') WHERE client_idx=('$client_idx')";
        if ($con->query($sql) === TRUE) {
            // echo "Record updated successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }
    }
    if ($zip != $clientDataArray["zip"]) {
        $sql="UPDATE clients_new SET zip=('$zip') WHERE client_idx=('$client_idx')";
        if ($con->query($sql) === TRUE) {
            // echo "Record updated successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }
    }
    if ($phone != $clientDataArray["phone"]) {
        $sql="UPDATE clients_new SET phone=('$phone') WHERE client_idx=('$client_idx')";
        if ($con->query($sql) === TRUE) {
            // echo "Record updated successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }
    }
    if ($email != $clientDataArray["email"]) {
        $sql="UPDATE clients_new SET email=('$email') WHERE client_idx=('$client_idx')";
        if ($con->query($sql) === TRUE) {
            // echo "Record updated successfully.";
        } else {
            echo "Error: " . $sql . "<br>" . $con->error;
        }
    }
}
$rep = addslashes($result->rep);
$completed = addslashes($result->completed);
$order_name = addslashes($result->order_name);
$tier = addslashes($result->tier);
$date = $result->date;
if ($tier == 0) {
    $guaranteed = 1; //true
} else {
    $guaranteed = 0; //false
}

$sql="INSERT INTO order_mst (client_idx, order_name, tier, grtd_flg, completed, rep, new, order_date)
VALUES ('$client_idx', '$order_name', '$tier', '$guaranteed', '$completed', '$rep', '$new', '$date')";

/*if (!mysqli_query($con,$sql)) {
    die('Error: ' . mysqli_error($con));
}*/
$order_idx = '';
if ($con->query($sql) === TRUE) {
    $order_idx = $con->insert_id;
    //  echo "New record created successfully. Last inserted ID is: " . $order_idx;
} else {
    //  echo "Error: " . $sql . "<br>" . $con->error;
}

$terms = addslashes($orderData[0]["terms"]);
$notes = addslashes($orderData[0]["notes"]);

$sql="INSERT INTO order_data (order_idx, terms, notes)
    VALUES ('$order_idx', '$terms', '$notes')";
if (!mysqli_query($con,$sql)) {
    die('Error: ' . mysqli_error($con));
}

$tempRemovedRings = array($result->rings_removed);
$tempAddedRings = array($result->rings_added);
$tempAccessories = array($result->accessories);
$tempCustomRings = array($result->customrings);
$tempStockbalances = array($result->stockbalances);

function objectToArray($object) {
    if (!is_object($object) && !is_array($object)) {
        return $object;
    }
    if (is_object($object)) {
        $object = get_object_vars($object);
    }
    return array_map('objectToArray', $object);
}


$removedRings = objectToArray($tempRemovedRings);
$addedRings = objectToArray($tempAddedRings);
$accessories = objectToArray($tempAccessories);
$customRings = objectToArray($tempCustomRings);
$stockBalances = objectToArray($tempStockbalances);

$temp = $removedRings[0];
$arrLength = count($temp);
for ($x = 0; $x < $arrLength; $x++) {
    $sku = addslashes($temp[$x]["SKU"]);
    $finish = addslashes($temp[$x]["finish"]);
    //for each of these insert into removed rings database
    $sql="INSERT INTO rings_removed (order_idx, sku, finish)
      VALUES ('$order_idx', '$sku', '$finish')";
    if (!mysqli_query($con,$sql)) {
        die('Error: ' . mysqli_error($con));
    }
    //  echo "1 record added";
}

$temp = $addedRings[0];
$arrLength = count($temp);
for ($x = 0; $x < $arrLength; $x++) {
    $sku = $temp[$x]["SKU"];
    $finish = $temp[$x]["finish"];
    $ringnote = $temp[$x]["notes"];
    //for each of these insert into removed rings database
    $sql="INSERT INTO rings_added (order_idx, sku, finish, notes)
      VALUES ('$order_idx', '$sku', '$finish', '$ringnote')";
    if (!mysqli_query($con,$sql)) {
        die('Error: ' . mysqli_error($con));
    }
    //  echo "1 record added";
}

$temp = $accessories[0];
$arrLength = count($temp);
for ($x = 0; $x < $arrLength; $x++) {
    $sku = $temp[$x]["SKU"];
    $finish = $temp[$x]["finish"];
    $ringnote = $temp[$x]["notes"];
    //for each of these insert into removed rings database
    $sql="INSERT INTO accessories (order_idx, sku, finish, notes)
      VALUES ('$order_idx', '$sku', '$finish', '$ringnote')";
    if (!mysqli_query($con,$sql)) {
        die('Error: ' . mysqli_error($con));
    }
    //  echo "1 record added";
}

$temp = $customRings[0];
$arrLength = count($temp);
for ($x = 0; $x < $arrLength; $x++) {
    $sku = $temp[$x]["sku"];
    $finish = $temp[$x]["finish"];
    $price = $temp[$x]["price"];
    //for each of these insert into removed rings database
    $sql="INSERT INTO rings_custom (order_idx, sku, finish, price)
      VALUES ('$order_idx', '$sku', '$finish', '$price')";
    if (!mysqli_query($con,$sql)) {
        die('Error: ' . mysqli_error($con));
    }
    //  echo "1 record added";
}

$temp = $stockBalances[0];
$arrLength = count($temp);
for ($x = 0; $x < $arrLength; $x++) {
    $id = $temp[$x]["id"];
    $price = $temp[$x]["price"];
    //for each of these insert into removed rings database
    $sql="INSERT INTO stockbalances (order_idx, id, price)
      VALUES ('$order_idx', '$id', '$price')";
    if (!mysqli_query($con,$sql)) {
        die('Error: ' . mysqli_error($con));
    }
    //  echo "1 record added";
}

$sql="INSERT INTO custom_display (order_idx, acrylic, top, side)
      VALUES ('$order_idx', '$acrylic', '$top', '$side')";
if (!mysqli_query($con,$sql)) {
    die('Error: ' . mysqli_error($con));
}
//  echo "1 record added";

echo $order_idx;

mysqli_close($con);

?>

