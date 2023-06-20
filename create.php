<?php

include 'connection.php';

$name = $_POST['name'];
$type = $_POST['type'];
$image = $_POST['image'];
$base64code = $_POST['base64code'];

$sql = "INSERT INTO asset
        SET
        name = '$name',
        type = '$type',
        image = '$image'
        ";

$result = $connect->query($sql);

if ($result) {
    // save image
    file_put_contents("../image/" . $image, base64_decode($base64code));

    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false));
}
