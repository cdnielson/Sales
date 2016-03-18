<?php

$con=mysqli_connect("","lbrook_sales","L@shbrook!","lbrook_sales");
$id = $_GET['id'];

if (mysqli_connect_errno()) {
    //  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$order_mst = mysqli_query($con, "SELECT * FROM order_mst WHERE order_idx = ('$id')");

$order_array = array();

//pushes to postion [0] of the array
while($row = mysqli_fetch_array($order_mst)) {
    array_push($order_array, array(
        'order_idx' => $row['order_idx'],
        'order_name' => $row['order_name'],
        'client_idx' => $row['client_idx'],
        'completed' => $row['completed'],
        'tier' => $row['tier'],
        'rep' => $row['rep'],
        'date' => $row['order_date']));
}

if ($order_array[0]['tier'] == 0) {
    $tier = "No Tier";
}
if ($order_array[0]['tier'] == 1) {
    $tier = "Tier One";
}
if ($order_array[0]['tier'] == 2) {
    $tier = "Tier Two";
}
if ($order_array[0]['tier'] == 3) {
    $tier = "Tier Three";
}
if ($order_array[0]['tier'] == 4) {
    $tier = "Tier Four";
}
if ($order_array[0]['tier'] == 5) {
    $tier = "Tier Four Guaranteed";
}

if ($order_array[0]['grtd_flg'] == 1) {
    $guaranteed = " Guaranteed";
} else {
    $guaranteed = "";
}

$client = $order_array[0]["client_idx"];

$client_mst = mysqli_query($con, "SELECT * FROM clients_new WHERE client_idx = ('$client')");

//pushes to position [1] of the array
while($row = mysqli_fetch_array($client_mst)) {
    array_push($order_array, array(
        'store_name' => $row['store_name'],
        'last_name' => $row['last_name'],
        'first_name' => $row['first_name'],
        'address' => $row['address'],
        'city' => $row['city'],
        'state' => $row['state'],
        'zip' => $row['zip'],
        'phone' => $row['phone'],
        'email' => $row['email']));
}

$order_data = mysqli_query($con, "SELECT * FROM order_data WHERE order_idx = ('$id')");

//pushes to position [2] of the array
while($row = mysqli_fetch_array($order_data)) {
    array_push($order_array, array(
        'terms' => $row['terms'],
        'notes' => $row['notes']));
}

$rings_added = mysqli_query($con, "SELECT * FROM rings_added WHERE order_idx = ('$id')");

$added_array = array();

while($row = mysqli_fetch_array($rings_added)) {
    array_push($added_array, array(
        'sku' => $row['sku'],
        'finish' => $row['finish'],
        'notes' => $row['notes']));
}

$rings_removed = mysqli_query($con, "SELECT * FROM rings_removed WHERE order_idx = ('$id')");

$removed_array = array();

while($row = mysqli_fetch_array($rings_removed)) {
    array_push($removed_array, array(
        'sku' => $row['sku'],
        'finish' => $row['finish']));
}

$accessories = mysqli_query($con, "SELECT * FROM accessories WHERE order_idx = ('$id')");

$accessories_array = array();

while($row = mysqli_fetch_array($accessories)) {
    array_push($accessories_array, array(
        'sku' => $row['sku'],
        'finish' => $row['finish'],
        'notes' => $row['notes']));
}

$custom = mysqli_query($con, "SELECT * FROM rings_custom WHERE order_idx = ('$id')");

$custom_array = array();

while($row = mysqli_fetch_array($custom)) {
    array_push($custom_array, array(
        'sku' => $row['sku'],
        'finish' => $row['finish'],
        'price' => $row['price']));
}

$sb = mysqli_query($con, "SELECT * FROM stockbalances WHERE order_idx = ('$id')");

$sb_array = array();

while($row = mysqli_fetch_array($sb)) {
    array_push($sb_array, array(
        'sku' => $row['id'],
        'price' => $row['price']));
}



$dc = mysqli_query($con, "SELECT * FROM custom_display WHERE order_idx = ('$id')");

$dc_array = array();

while($row = mysqli_fetch_array($dc)) {
    array_push($dc_array, array(
        'acrylic' => $row['acrylic'],
        'top' => $row['top'],
        'side' => $row['side']));
}
$acrylic = $dc_array[0]["acrylic"];
$top = $dc_array[0]["top"];
$side = $dc_array[0]["side"];


$subtotal = 0;

?>
<html>
<head lang="en">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1">
    <meta http-equiv="expires" content="0">
    <title>Lashbrook Signature</title>


    <script src="assets/jquery.min.js"></script>
    <script src="jquery.signaturepad.min.js"></script>
    <script src="assets/json2.min.js"></script>
    <script src="assets/flashcanvas.js"></script>

    <link rel="stylesheet" href="assets/jquery.signaturepad.css">

    <script>
        var options = {
            bgColour : '#FFF'
            , drawOnly : true
        };

        $(document).ready(function () {
            $('.sigPad').signaturePad(options);
            var api = $('.sigPad').signaturePad({displayOnly:true});
            api.regenerate(sig);
        });


    </script>
</head>
<style>
    body {
        background: #003152;
        color: black;
    }
    #order {
        display: flex;
        flex-direction: column;
        flex-wrap: nowrap;
        justify-content: flex-start;
        border-top: 1px dotted black;
        border-right: 1px dotted black;
        //max-width: 800px;
        background: white;
        margin-left: 20px;
        margin-right: 20px;
    }
    .field {
        border-bottom: 1px dotted black;
        border-left: 1px dotted black;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        padding-left: 5px;
    }
    .subfield {
        border-left: 1px dotted black;
        width: 75px;
        text-align: end;
        padding-right: 30px;
    }
    .header {
        font-weight: bold;
    }
    .signaturecontainer {
        padding-left: 50px;
    }
</style>
<body>
    <div><img src="../images/lb_logo_white.jpg"></div>
    <div id="order">
        <div>

            <div class="field"><? echo "Order ID: " . $order_array[0]["order_idx"]; ?></div>
            <div class="field"><? echo "Date: " . $order_array[0]["date"]; ?></div>
            <div class="field"><? echo "Order Name: " . $order_array[0]["order_name"]; ?></div>
            <div class="field"><? echo "Rep: " . $order_array[0]["rep"]; ?></div>
            <div class="field"><? echo "Store Name: " . $order_array[1]["store_name"]; ?></div>
            <div class="field"><? echo "Last Name: " . $order_array[1]["last_name"]; ?></div>
            <div class="field"><? echo "First Name: " . $order_array[1]["first_name"]; ?></div>
            <div class="field"><? echo "Address: " . $order_array[1]["address"]; ?></div>
            <div class="field"><? echo "City: " . $order_array[1]["city"]; ?></div>
            <div class="field"><? echo "State: " . $order_array[1]["state"]; ?></div>
            <div class="field"><? echo "Zip: " . $order_array[1]["zip"]; ?></div>
            <div class="field"><? echo "Phone: " . $order_array[1]["phone"]; ?></div>
            <div class="field"><? echo "Email: " . $order_array[1]["email"]; ?></div>
            <div class="field"><? echo "Terms: " . $order_array[2]["terms"]; ?></div>
            <div class="field"><? echo "Notes: " . $order_array[2]["notes"]; ?></div>
            <div class="field"><?echo $tier; ?></div>

            <?
            $con2 = mysqli_connect("","lbrook_app_rings","L@shbrook!","lbrook_app_rings");
            if (mysqli_connect_errno()) {
                echo "Failed to connect to MySQL: " . mysqli_connect_error();
            }
            $check = empty($added_array);
            if ($check == false) {

                foreach ($added_array as $a) {
                    $sku = $a['sku'];
                    $finish = $a['finish'];
                    $ring_data = mysqli_query($con2, "SELECT * FROM rings WHERE sku = ('$sku') AND finish = ('$finish')");
                    while($row = mysqli_fetch_array($ring_data)) {
                        if ($tier == "Tier One") {
                            if ($row['tier'] == 1) {
                                $added .= "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                                $subtotal = $subtotal + $row['price'];
                            }
                            if ($row['tier'] != 1) {
                                $addedplus .= "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                                $subtotal = $subtotal + $row['price'];
                            }
                        }
                        if ($tier == "Tier Two") {
                            if ($row['tier'] == 1 || $row['tier'] == 2) {
                                $added .= "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                                $subtotal = $subtotal + $row['price'];
                            }
                            if ($row['tier'] == 3 || $row['tier'] == 4 || $row['tier'] == 5 || $row['tier'] == 0) {
                                $addedplus .= "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                                $subtotal = $subtotal + $row['price'];
                            }
                        }
                        if ($tier == "Tier Three") {
                            if ($row['tier'] == 1 || $row['tier'] == 2 || $row['tier'] == 3) {
                                $added .= "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                                $subtotal = $subtotal + $row['price'];
                            }
                            if ($row['tier'] == 4 || $row['tier'] == 5 || $row['tier'] == 0) {
                                $addedplus .= "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                                $subtotal = $subtotal + $row['price'];
                            }
                        }
                        if ($tier == "Tier Four" || $tier == "Tier Four Guaranteed") {
                            if ($row['tier'] == 1 || $row['tier'] == 2 || $row['tier'] == 3 || $row['tier'] == 4) {
                                $added .= "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                                $subtotal = $subtotal + $row['price'];
                            }
                            if ($row['tier'] == 0) {
                                $addedplus .= "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                                $subtotal = $subtotal + $row['price'];
                            }
                        }
                        if ($tier == "No Tier") {
                            $addedplus .= "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                            $subtotal = $subtotal + $row['price'];
                        }
                    }
                }
            }
            $check = empty($added);
            if ($check == false) {
                echo "<div class='field header'>Rings in the Tier</div>";
                echo $added;
            }

            $con2 = mysqli_connect("","lbrook_app_rings","L@shbrook!","lbrook_app_rings");
            if (mysqli_connect_errno()) {
                echo "Failed to connect to MySQL: " . mysqli_connect_error();
            }

            $check = empty($removed_array);
            if ($check == false) {
                echo "<div class='field header'>With the following rings removed from the Tier:</div>";
                foreach ($removed_array as $a) {
                    $sku = $a['sku'];
                    $finish = $a['finish'];
                    $ring_data = mysqli_query($con2, "SELECT * FROM rings WHERE sku = ('$sku') AND finish = ('$finish')");
                    while($row = mysqli_fetch_array($ring_data)) {

                        echo "<div class='field'>" . $row['sku'] . " - " . $row['finish'] . "</div>";
                    }
                }
            }

            $check = empty($addedplus);
            if ($check == false) {
                echo "<div class='field header'>Added Rings</div>";
                echo $addedplus;
            }

            $check = empty($accessories_array);
            if ($check == false) {
                echo "<div class='field header'>Other Items Added:</div>";
                foreach ($accessories_array as $a) {
                    $sku = $a['sku'];
                    $finish = $a['finish'];
                    $accessories_data = mysqli_query($con2, "SELECT * FROM rings WHERE sku = ('$sku') AND finish = ('$finish')");
                    while ($row = mysqli_fetch_array($accessories_data)) {

                        echo "<div class='field'><div>" . $row['sku'] . " - " . $row['finish'] . " - " . $a['notes'] . "</div><div class='subfield'>$" . $row['price'] . "</div></div>";
                        $subtotal = $subtotal + $row['price'];
                    }
                }
            }

            $check = empty($dc_array);
            if ($check == false) {
                echo "<div class='field header'>Custom Display Colors</div>";
                echo "<div class='field'><div>Acrylic top: " . $acrylic . "</div><div class='subfield'></div></div>";
                echo "<div class='field'><div>Top: " . $top . "</div><div class='subfield'></div></div>";
                echo "<div class='field'><div>Side: " . $side . "</div><div class='subfield'></div></div>";
            }

            $check = empty($custom_array);
            if ($check == false) {
                echo "<div class='field header'>Custom Skus:</div>";
                foreach ($custom_array as $a) {
                    echo "<div class='field'><div>" . $a['sku'] . " - " . $a['finish'] . "</div><div class='subfield'>$" . $a['price'] . "</div></div>";
                    $subtotal = $subtotal + $a['price'];
                }
            }

            $check = empty($sb_array);
            if ($check == false) {
                echo "<div class='field header'>Stock Balances:</div>";
                foreach ($sb_array as $a) {
                    echo "<div class='field'><div>" . $a['id'] . "</div><div class='subfield'>$" . $a['price'] . "</div></div>";
                    $subtotal = $subtotal + $a['price'];
                }
            }
            ?>
            <div class="field header"><div>Subtotal:</div><div class="subfield"><? echo "$" . $subtotal ?></div></div>
            <?
            $shipping = 0;
            if ($subtotal < 3001) {
                $shipping = 20;
            }
            if ($subtotal > 3000 && $subtotal < 6001) {
                $shipping = 35;
            }
            if ($subtotal > 6000 && $subtotal < 10001) {
                $shipping = 50;
            }
            if ($subtotal > 10000) {
                $shipping = 75;
            }
            ?>
            <div class="field"><div>Shipping Costs:</div><div class="subfield"><? echo "$" . $shipping ?></div></div>
            <?
            $total = $subtotal + $shipping;
            ?>
            <div class="field header" style="font-size: large"><div>Total:</div><div class="subfield"><? echo "$" . $total ?></div></div>
        </div>
        <?

        $image = mysqli_query($con, "SELECT * FROM signatures WHERE order_idx = ('$id')");

        $image_array = array();

        while($row = mysqli_fetch_array($image)) {
            array_push($image_array, array(
                'order_idx' => $row['order_idx']));
        }
        $image_exists = $image_array[0]['order_idx'];
        $check = empty($image_exists);
        if ($check == true) {
            echo '<div class="signaturecontainer">
                <form method="post" action="signature.php" class="sigPad">
                    <!--<label for="name">Print your name</label>
                    <input type="text" name="name" id="name" class="name">-->
                    <p class="drawItDesc">Sign Here</p>
                    <ul class="sigNav">
                        <li class="clearButton"><a href="#clear">Clear</a></li>
                    </ul>
                    <div class="sig sigWrapper">
                        <div class="typed"></div>
                        <canvas class="pad" width="800" height="200"></canvas>
                        <input type="hidden" name="output" class="output">
                        <input type="hidden" name="id" value="' . $id . '">
                        <input type="hidden" name="repEmail" value="' . $repEmail . '">
                    </div>
                    <button type="submit">Upload Signature and Email Order (please tap/click only once)</button>
                </form>
            </div>';
        } else {
            echo '<div><p>A signature for this order already exists.</p></div>';
        }
        ?>
</body>
</html>


