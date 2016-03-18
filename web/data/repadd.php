<?php
$con=mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");
// why isn't this working?
// Check connection
if (mysqli_connect_errno()) {
    //  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$f = file_get_contents('logins.json');

//$f2 = substr($f, 3);

//var_dump($f2);

$result = json_decode($f);



foreach($result as $r) {

    $username = addslashes($r->username);

    $pin = addslashes($r->pin);

    $email = addslashes($r->email);



    $sql="INSERT INTO reps (username, pin, email)

    VALUES ('$username', '$pin', '$email')";

    if (!mysqli_query($con,$sql)) {

        die('Error: ' . mysqli_error($con));

    }

    echo "1 record added";

}







mysqli_close($con);



?>



