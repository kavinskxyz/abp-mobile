<?php
include 'connection.php';

$sql = "SELECT * FROM asset";
$result = $connect->query($sql);

if ($result->num_rows > 0) {
    $data = array();
    while($get_row = $result->fetch_assoc()){
        $data[] = $get_row;
    }

    echo json_encode(array(
        "success"=>true,
        "data"=>$data,
    ));
}else{
    echo json_encode(array(
        "success"=>false,
    ));
}