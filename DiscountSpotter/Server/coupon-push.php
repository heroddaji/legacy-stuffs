<?php

require("connect.php");
	
	
	//first check if found any signoffDate is NULL, if found then prepare to push
	$query =mysql_query("SELECT * FROM Notification WHERE signedoffDate IS NULL ");
	if (!$query) {
		 die('Could not query:' . mysql_error());
	}
	
	$num_rows = 0;
	$num_rows = mysql_num_rows($query);
	if($num_rows > 0) //so there is some new coupons, must push
	{
		$token_to_push = array();//hold all the token which will get pushed
		
		//get each distinct token and keep in $token_array
		$query = mysql_query("SELECT DISTINCT token FROM Notification WHERE signedoffDate IS NULL ");
		$token_array = array();
		while ($row = mysql_fetch_array($query)) {    
		    array_push($token_array,$row[0]);    
		}
		//print_r($token_array);		
		//DONE
		
		//now for each token, find a match in the Subscrition with 3 value 'token','shopID' and 'productCategory'
		//if found, add that token to push list
		for($i = 0; $i < count($token_array); $i++){
			$aToken = $token_array[$i];
			
			$query2 = mysql_query("SELECT * FROM Notification WHERE token = '$aToken' AND signedoffDate IS NULL ");
			while ($row2 = mysql_fetch_array($query2)) {    
			   $aShopID = $row2['shopID'];
			   $aPRoductCategory = $row2['productCategory'];
			 
				// echo $aShopID; 
				 //echo $aPRoductCategory; 
			 		  
			   $query3 = mysql_query("SELECT * FROM Subscription WHERE token = '$aToken' AND shopID = '$aShopID' AND productCategory = '$aPRoductCategory'  ");
			   if ( ($num = mysql_num_rows($query3)) > 0 ){
			   		//echo 'found'; 
			   		array_push($token_to_push,$aToken);
			   		break;
			   }
			}
		}
		
		print_r($token_to_push);		
		if( count($token_to_push) > 0){
			echo 'ad</br>';
			sendPushToApple($token_to_push);	
			
		}
		
	}
	
	//tokens is the push array
	function sendPushToApple($tokens){
		
		for($i = 0 ; $i < count($tokens); $i++){
		echo 'hehe</br>';
		$token = $tokens[$i];
		
			//content of the push message
			$payload['aps'] = array('alert' => 'New coupons available, you should check them', 'badge' => 1, 'sound' => 'default');
			$payload = json_encode($payload);
			
			//connection gate, and certificate file name for push notification
			$apnsHost = 'gateway.sandbox.push.apple.com';
			$apnsPort = 2195;
			$apnsCert = 'apns_dev.pem';
			
			$streamContext = stream_context_create();
			stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
			$apns = stream_socket_client('ssl://' . $apnsHost . ':' . $apnsPort, $error, $errorString, 2, STREAM_CLIENT_CONNECT, $streamContext);
					
			//the message binary
			$msg = chr(0) . pack("n",32) . pack('H*', str_replace(' ', '', $token)) . pack("n",strlen($payload)) . $payload;
			//the push message format
			$apnsMessage = chr(0) . chr(0) . chr(32) . pack('H*', str_replace(' ', '', $token)) . chr(0) . chr(strlen($payload)) . $payload;
	
			fwrite($apns, $msg);//push the message	
		}
		fclose($apns);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*
	while($row = mysql_fetch_array($querySelect)){
		array_push($tokenArray,$row[0]);
	}
	
	for($i=0; $i< count($tokenArray);$i++){
		$token = $tokenArray[$i];
		echo $token;
		
		$querySelect =mysql_query("SELECT * FROM Notification WHERE token = '$token' AND signedoffDate IS NULL ");
		if (!$querySelect) {
		 die('Could not query:' . mysql_error());
		}	
		$count=0;
		while($row = mysql_fetch_array($querySelect)){
			$count++;	
		}
		echo '</br>';
		echo $count;
		
		if ($coun > 0){
			
			//first get the category of this coupon
			$query =mysql_query("SELECT productCategory FROM Coupon WHERE token = '$token' AND signedoffDate IS NULL ");
			
			//check if user subscribe to the category of the coupon
			
			
				
			//content of the push message
			$payload['aps'] = array('alert' => 'New coupons available, you should check them', 'badge' => $count, 'sound' => 'default');
			$payload = json_encode($payload);
			
			//connection gate, and certificate file name for push notification
			$apnsHost = 'gateway.sandbox.push.apple.com';
			$apnsPort = 2195;
			$apnsCert = 'apns_dev.pem';
			
			$streamContext = stream_context_create();
			stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
			$apns = stream_socket_client('ssl://' . $apnsHost . ':' . $apnsPort, $error, $errorString, 2, STREAM_CLIENT_CONNECT, $streamContext);
					
			//the message binary
			$msg = chr(0) . pack("n",32) . pack('H*', str_replace(' ', '', $token)) . pack("n",strlen($payload)) . $payload;
			//the push message format
			$apnsMessage = chr(0) . chr(0) . chr(32) . pack('H*', str_replace(' ', '', $token)) . chr(0) . chr(strlen($payload)) . $payload;
	
			fwrite($apns, $msg);//push the message	
			
		}
	}
	
		//close connection
		fclose($apns);
*/
?>