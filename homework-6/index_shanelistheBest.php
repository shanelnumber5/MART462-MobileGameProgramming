<?php 
//The server returns JSON data 
$arr=array('name'=>'Han Solo','name2'=>'Darth Vader','name3'=>'Luke Skywalker','name4'=>'Princess Leia','name5'=>'Chewbacca'); 
$result=json_encode($arr); 

$callback=$_GET['callback']; 
echo $callback."($result)";
?>