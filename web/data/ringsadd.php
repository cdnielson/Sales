<?php

$con=mysqli_connect("","lbrook_app_rings","L@shbrook!","lbrook_app_rings");



if (mysqli_connect_errno()) {

    echo "Failed to connect to MySQL: " . mysqli_connect_error();

}

$f = file_get_contents('tiers.json');

$f2 = substr($f, 3);

//var_dump($f2);

$result = json_decode($f2);



foreach($result as $r) {

    $id = addslashes($r->id);

    $category = addslashes($r->category);

    $sku = addslashes($r->SKU);

    $finish = addslashes($r->finish);

    $price = addslashes($r->price);

    $tier = addslashes($r->tier);

    $image = addslashes($r->image);

    $combo = addslashes($r->combo);



    $sql="INSERT INTO rings (id, category, sku, finish, price, tier, image, combo)

    VALUES ('$id', '$category', '$sku', '$finish', '$price', '$tier', '$image', '$combo')";

    if (!mysqli_query($con,$sql)) {

        die('Error: ' . mysqli_error($con));

    }

    echo "1 record added";

}







mysqli_close($con);



?>



