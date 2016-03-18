<?php
$con=mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");

if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
$f = file_get_contents('clientsDB.json');
// escape variables for security
$result = json_decode($f);


foreach($result as $r) {
    $order_idx = addslashes($r->order_idx);
    $terms = addslashes($r->terms);
    $notes = addslashes($r->notes);

    $sql="INSERT INTO order_data (order_idx, terms, notes)
    VALUES ('$order_idx', '$terms', '$notes')";
    if (!mysqli_query($con,$sql)) {
        die('Error: ' . mysqli_error($con));
    }
    echo "1 record added";
}



mysqli_close($con);

?>

