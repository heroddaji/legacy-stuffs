<?php
	//$host = 'tester12345.db.5287555.hostedresource.com';
	//$user = 'tester12345';
	//$pass = 'Abc123abc';

	//$host = 'localhost';
	//$user = 'root';
	//$pass = 'root';

	$host = 'dbint020025';
	$user = 'u020025_iphone';
	$pass = 'teh83bet';
	
$con = mysql_connect($host,$user,$pass);

if (!$con)
  {
  die('Could not connect: ' . mysql_error());
 }
 
 //$database = "tester12345";
  $database = "db020025_iphone_demo";
mysql_select_db($database, $con);

?>