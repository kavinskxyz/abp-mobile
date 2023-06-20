<?php

$host       = 'localhost';
$user       = 'root';
$password   = '';
$db         = 'ABPMOBILE';
 
$connect = new mysqli($host, $user, $password, $db);

if($connect){
    
}else{
    echo "Connection failed";
}