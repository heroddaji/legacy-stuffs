
<?php

	require("connect.php");
	
	//echo "haha";
	/*echo $query =  mysql_query("SELECT DATEDIFF('2010-7-30 12:00:00',now()) AS DiffDate");
						echo "</br>";
						echo $rows = mysql_num_rows($query) . " row";
						echo "</br>";
						echo mysql_result($query,0) . " days";
	*/					
	
	//class-----------------------------------
	class SimpleClass
	{
	    // property declaration
	    public $locArray = array();
	}
	$cl = new SimpleClass();

	

	/*  METHOD PARAMETER
	METHOD PARAMETER
	METHOD 1: GET REQUEST FOR LOCATION AND COUPON, THEN RETURN THE DATA
	METHOD 2: GET REQUEST FOR REGISTER USER DEVICE TOKEN, EMAIL AND PUSH NOTIFICATION, THEN CHANGE TO DATABASE
	METHOD 3: GET REQUEST SUBCRIBE/UNSUBSCRIBE USER CHOICE OF SHOP AND/OR CATEOGRY, THEN CHANGE TO DATABASE
	METHOD 4: GET REQUEST FOR ALL SUBSCRIPTION OF USER, RETURN DATA
	METHOD 5: GET REQUEST FOR NEW NOTIFICATION, RETURN DATA
	METHOD 6: GET REQUEST FOR A LOCATION BY THE COUPONID
	METHOD 7: GET REQUEST FOR A SIGNEDOFF COUPON BY A USER TOKEN
	METHOD 8: EMAIL VALIDATION
	
	*/
	
	
	
	/*
	 * METHOD 1, GET REQUEST FROM THE APP, AND RETURN LOCATION AND COUPON INFO IN JSON FORMAT
	 */ 
	if($_GET['method'] == "1" )
	{
		
		//http://phptest.isaac.nl/iphone/phpfile.php?method=1&userLatitude=51.4305&userLongitude=5.484&userRadius=3000
		
		
		if ( is_numeric ($_GET['userLatitude'] )  == TRUE)
		{
			$lat1 = $_GET['userLatitude'];
			
		}
		else
		{
			echo "error in input, required a number";		
			return;
		} 
		
		if ( is_numeric ($_GET['userLongitude'] )  == TRUE)
		{
			$lon1 =  $_GET['userLongitude'];
			
		}
		else
		{
			echo "error in input, required a number";		
			return;
		} 
		
		if ( is_numeric ($_GET['userRadius'] )  == TRUE && $_GET['userRadius'] != 0)
		{
			$radius = $_GET['userRadius'];
		}
		else
		{
			echo "error in input, required a number";		
			return;
		} 

		
		
		$radiusToLatitudeIntervalUp = $lat1 + ($radius/111200);//1 lattitude = 111.2 km
		$radiusToLongitudeIntervalUp = $lon1 + ($radius/69370);//1 longitude = 69.37 km
		
		$radiusToLatitudeIntervalDown = $lat1 - ($radius/111200);//1 lattitude = 111.2 km
		$radiusToLongitudeIntervalDown = $lon1 - ($radius/69370);//1 longitude = 69.37 km
		
		$locationQuery = mysql_query("SELECT * FROM Location WHERE (latitude >".$radiusToLatitudeIntervalDown
									."AND latitude <".$radiusToLatitudeIntervalUp.")"
									."AND (longitude >".$radiusToLongitudeIntervalDown
									."AND longitude <".$radiusToLongitudeIntervalUp.")");
				
		//echo $radiusToLatitudeIntervalUp. '</br>';
		//echo $radiusToLongitudeIntervalUp. '</br>';
		//echo $radiusToLatitudeIntervalDown. '</br>';
		//echo $radiusToLongitudeIntervalDown. '</br>';
		
				
		$cl->locArray = array();
		
		//echo mysql_num_rows($locationQuery) . '</br>';
		
		while($row = mysql_fetch_array($locationQuery))
		  {	
		  	//calculate distance from user location and database location
		  	 $R = 6371000 ; //meter
		 	 $lat2 = $row['latitude'];
		 	 $lon2 = $row['longitude'];
		 	 $dLat = deg2rad($lat2 - $lat1);
			 $dLon = deg2rad($lon2 - $lon1);
			 $a = sin($dLat/2) * sin($dLat/2) + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($dLon/2) *sin($dLon/2);
			 $c = 2 * atan2(sqrt($a),sqrt(1-$a));
			 $d = $R * $c ;  	
			 
			 //if distance is within the radius, then get on the coupon, and add to locaiton array
			 if ($d <= $radius){
			 	//echo 'distant is:' . $d . '</br>';
				 $coupons = array();
			 
				 //now search coupon if location is a shop type
				 if($row['type'] == 'shop')
				 {
			 		$couponQuery = mysql_query("SELECT * FROM Coupon WHERE shopID =\"".$row['locationID']."\" AND DATEDIFF(toDate,now())>=0");

			 		while($row2 = mysql_fetch_array($couponQuery))
			 		{
						
							/*$toDate = $row2['toDate'];
							echo $toDate . "is todate \n";
							
							echo $query =  mysql_query("SELECT DATEDIFF('$toDate',now()) AS DiffDate");
							echo "</br>";
							echo $rows = mysql_num_rows($query) . " row";
							echo "</br>";
							echo mysql_result($query,0) . " days";
							*/
						
						//get date diff	
						$toDate = $row2['toDate'];	
						$query =  mysql_query("SELECT DATEDIFF('$toDate',now()) AS DiffDate");
						$remainDays = mysql_result($query,0);
						 
						//push to array used for json encode 				 			
			 			array_push($coupons,array('couponID' => $row2['couponID'],
			 									'productName' => $row2['productName'],
												'productDescription' => $row2['productDescription'],
												'productBrand' => $row2['productBrand'],
												'productCategory' => $row2['productCategory'],
												'productPrice' => $row2['productPrice'],
												'productImage' => $row2['productImage'],
												'discountDescription' => $row2['discountDescription'],
												'discountType' => $row2['discountType'],
												'discountValue' => $row2['discountValue'],
												'fromDate' => $row2['fromDate'],
												'toDate' => $row2['toDate'],
												'shopID' => $row2['shopID'],
												'barcode' => $row2['barcode'],
												'remainDays' => $remainDays));	
					
					
			 		}
						
	
				 }
			 
			 	//push location to array
				array_push($cl->locArray,array('locationID'=>$row['locationID'],
											'addressHint'=>$row['addressHint'],
											'type'=>$row['type'],
											'name'=>$row['name'],
											'description'=>$row['description'],
											'latitude'=>$row['latitude'],
											'longitude'=>$row['longitude'],
											'phone'=>$row['phone'],
											'email'=>$row['email'],
											'homepageURL'=>$row['homepageURL'],
											'coupons'=>$coupons ));
			 } 
		  }
		print_r(json_encode($cl));
		//http://phptest.isaac.nl/iphone/phpfile.php?method=1&userLatitude=51.43&userLongitude=5.43&userRadius=5000
		
	}
	
	/*
	 * METHOD 2, FOR REGISTERING USER INFO
	 */
	
	if($_GET['method'] == "2" )
	{
		$token = $_GET['token'];	 
		$email = $_GET['email'];
		$pushAlert = $_GET['pushAlert'];
		$pushBadge = $_GET['pushBadge'];
		$pushSound = $_GET['pushSound'];
		
		echo "run method 2 </br>";
		
		$querySelect = mysql_query("SELECT token FROM User WHERE token = '$token' ");
		if (!$querySelect) {
	   		 die('Could not query:' . mysql_error());
		}
		
		$row = mysql_fetch_row($querySelect);	
		echo $row;
		// if row is null, mean no token is found, insert new record
		if($row == NULL)	
		{			
		    $queryInsert =mysql_query( "INSERT INTO User (id, token, email,pushAlert, pushBadge,pushSound) VALUES ('','$token','$email','$pushAlert', '$pushBadge','$pushSound') " ) ;
			if (!$queryInsert) {
	   		   die('Could not query insert:' . mysql_error());
			}
		     echo "insert in method 2 sucess";
		}
		//else mean this is exist user, check if user info is old or new, if new , update the table
		else
		{
			/*UPDATE Persons
			SET Address='Nissestien 67', City='Sandnes'
			WHERE LastName='Tjessem' AND FirstName='Jakob'
			*/
			
			$queryUpdate = mysql_query("UPDATE User SET email='$email',pushAlert='$pushAlert',pushBadge='$pushBadge',pushSound='$pushSound' WHERE token = '$token' ");
			if (!$queryUpdate) {
	   		   die('Could not query update:' . mysql_error());
			}
			echo 'update in method 2 success';
		}
	}
		
	
	/*
	 * METHOD 3, SUBSCRIBE USER CHOICE OF SHOP AND/OR CATEGORY
	 */
	 
	if($_GET['method'] == "3" ){
		
		//http://phptest.isaac.nl/iphone/phpfile.php?method=3&token=%@&locationID=%@&category=%@&subscribe=%@
		
		//MISSING VALIDATE VALID PARAMETER HERE
		///....
		
		$token = $_GET['token']; 
		$shopID = $_GET['shopID'];   //ex: shop, category
		$productCategory = $_GET['productCategory']; //ex: shop01, book, game
		$subscribe = $_GET['subscribe']; //ex: YES, NO
				
		$querySelect = mysql_query("SELECT * FROM Subscription WHERE token = '$token' AND shopID = '$shopID' and productCategory = '$productCategory' ");
		
		if (!$querySelect) {
	   		 die('Could not query:' . mysql_error());
		}
		
		$row = mysql_fetch_row($querySelect);	
		
		// if row is null, mean no value is found
		// insert new record if user want to subscribe
		// else do nothing if user want to unsubscribe
		if($row == NULL){			
			if($subscribe == 'YES'){
			    $queryInsert =mysql_query( "INSERT INTO Subscription (id, token, shopID ,productCategory) VALUES ('','$token','$shopID','$productCategory') " ) ;
				if (!$queryInsert) {
		   		   die('Could not query insert:' . mysql_error());
				}	
				
				echo 'insert in method 3 success';
			}
			else if($subscribe == 'NO'){
				;
			}
		}
		
		//else if row is not null, mean find the record
		// do nothing if user want to subscribe
		// delete the record if user want to unsubcribe
		else
		{
			if($subscribe == 'YES'){
				;
			}
			else if($subscribe == 'NO') {
				
				/*DELETE FROM Persons
				  WHERE LastName='Tjessem' AND FirstName='Jakob'
				*/
				
				$queryUpdate = mysql_query("DELETE FROM Subscription WHERE token = '$token' AND shopID = '$shopID' and productCategory = '$productCategory' ");
				if (!$queryUpdate) {
		   		   die('Could not query update:' . mysql_error());
				}
				
				echo 'delete in method 3 success';
			}
		}
		
	}
	
	/*
	 * METHOD 4, SEND BACK TO THE APP THE USER SUBSCRIPTION
	 */
	if($_GET['method'] == "4" ){
		$token = $_GET['token'];
		
		$querySelect = mysql_query("SELECT * FROM Subscription WHERE token = '$token' ");
		if(!$querySelect) die('Could not query select:' . mysql_error());
		
		//$subscription = array();
		while($row=mysql_fetch_array($querySelect)){
			array_push($cl->locArray,array('shopID'=>$row['shopID'],
										   'productCategory'=>$row['productCategory']));
		
		
		}
		print_r(json_encode($cl));
	}

	/*
	 * METHOD 5, SEND BACK TO THE APP THE NEW COUPON AND ITS LOCATION IN THE NOTIFICATION
	 * sample call: http://phptest.isaac.nl/iphone/phpfile.php?method=5&token=1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9
	 */
	if($_GET['method'] == "5" ){
		$token = $_GET['token'];
		
		$querySelect = mysql_query("SELECT * FROM Notification WHERE token = '$token' AND signedoffDate IS NULL");
		if(!$querySelect) die('Could not query select:' . mysql_error());
		
		//$subscription = array();
		while($row=mysql_fetch_array($querySelect)){
			array_push($cl->locArray,array('shopID'=>$row['shopID'],'couponID'=>$row['couponID']));		
		
		}
		print_r(json_encode($cl));
	}
	
	/*
	 * METHOD 6, SEND BACK TO THE LOCATION BY THE COUPONID REQUEST
	 * sample call: http://phptest.isaac.nl/iphone/phpfile.php?method=6&couponID=%@",
	 */
	if($_GET['method'] == "6" ){
		$couponID = $_GET['couponID'];
		
		//first get the locationID from couponID
		$querySelect = mysql_query("SELECT locationID FROM Coupon WHERE couponID = '$couponID'");
		if(!$querySelect) die('Could not query select:' . mysql_error());
	
		while($row=mysql_fetch_array($querySelect)){
			$locationID = $row[0];
		}
		
		//now get all the location info and encode it
		$querySelect = mysql_query("SELECT * FROM Location WHERE locationID = '$locationID'");
		if(!$querySelect) die('Could not query select:' . mysql_error());
		
		$cl->locArray = array();
		while($row = mysql_fetch_array($querySelect)){	 
			
			//load coupon in that location
	 		$couponQuery = mysql_query("SELECT * FROM Coupon WHERE shopID =\"".$row['locationID']."\"");
			$coupons = array();
	 		while($row2 = mysql_fetch_array($couponQuery))
	 		{
	 					//get date diff	
						$toDate = $row2['toDate'];	
						$query =  mysql_query("SELECT DATEDIFF('$toDate',now()) AS DiffDate");
						$remainDays = mysql_result($query,0);
						 
						//push to array used for json encode 				 			
			 			array_push($coupons,array('couponID' => $row2['couponID'],
			 									'productName' => $row2['productName'],
												'productDescription' => $row2['productDescription'],
												'productBrand' => $row2['productBrand'],
												'productCategory' => $row2['productCategory'],
												'productPrice' => $row2['productPrice'],
												'productImage' => $row2['productImage'],
												'discountDescription' => $row2['discountDescription'],
												'discountType' => $row2['discountType'],
												'discountValue' => $row2['discountValue'],
												'fromDate' => $row2['fromDate'],
												'toDate' => $row2['toDate'],
												'shopID' => $row2['shopID'],
												'barcode' => $row2['barcode'],
												'remainDays' => $remainDays));		
				 		

	 		} 
		 
		 	//push location to array
			array_push($cl->locArray,array('locationID'=>$row['locationID'],
											'addressHint'=>$row['addressHint'],
											'type'=>$row['type'],
											'name'=>$row['name'],
											'description'=>$row['description'],
											'latitude'=>$row['latitude'],
											'longitude'=>$row['longitude'],
											'phone'=>$row['phone'],
											'email'=>$row['email'],
											'homepageURL'=>$row['homepageURL'],
											'coupons'=>$coupons ));

		} 
		
		print_r(json_encode($cl));
	}
	
	/*
	 * METHOD 7, GET SIGNEDOFFDATE AND ALTER THE DATABASE
	 * sample call: http://phptest.isaac.nl/iphone/phpfile.php?method=7&token=&couponID=%@&signedoffDate=",
	 */
	if($_GET['method'] == "7" ){
		$token = $_GET['token'];
		$couponID = $_GET['couponID'];
		$signedoffDate = date('Y-m-d H:i:s', time() );
		echo $signedoffDate;
	
		$queryUpdate = mysql_query("UPDATE Notification SET signedoffDate = '$signedoffDate' WHERE token = '$token' AND couponID = '$couponID' ");
			if (!$queryUpdate)  die('Could not query update:' . mysql_error());	
			
		echo 'execute method 7 success';

	}
	
	/*
	 * METHOD 8, EMAIL VALIDATION, RETURN TRUE IF VALID, ELSE FALSE
	 * source:http://www.linuxjournal.com/article/9585?page=0,3
	 * credit all to that developer
	 *
	 * Description
	 *
		Validate an email address.
		Provide email address (raw input)
		Returns true if the email address has the email 
		address format and the domain exists.
			
	 */
	if($_GET['method'] == "8" ){
			
		$email = $_GET['email'];		
			
		 $isValid = true;
		   $atIndex = strrpos($email, "@");
		   if (is_bool($atIndex) && !$atIndex)
		   {
		      $isValid = false;
		   }
		   else
		   {
		      $domain = substr($email, $atIndex+1);
		      $local = substr($email, 0, $atIndex);
		      $localLen = strlen($local);
		      $domainLen = strlen($domain);
		      if ($localLen < 1 || $localLen > 64)
		      {
		         // local part length exceeded
		         $isValid = false;
		      }
		      else if ($domainLen < 1 || $domainLen > 255)
		      {
		         // domain part length exceeded
		         $isValid = false;
		      }
		      else if ($local[0] == '.' || $local[$localLen-1] == '.')
		      {
		         // local part starts or ends with '.'
		         $isValid = false;
		      }
		      else if (preg_match('/\\.\\./', $local))
		      {
		         // local part has two consecutive dots
		         $isValid = false;
		      }
		      else if (!preg_match('/^[A-Za-z0-9\\-\\.]+$/', $domain))
		      {
		         // character not valid in domain part
		         $isValid = false;
		      }
		      else if (preg_match('/\\.\\./', $domain))
		      {
		         // domain part has two consecutive dots
		         $isValid = false;
		      }
		      else if
					(!preg_match('/^(\\\\.|[A-Za-z0-9!#%&`_=\\/$\'*+?^{}|~.-])+$/',
		              str_replace("\\\\","",$local)))
		      {
		         // character not valid in local part unless 
		         // local part is quoted
		         if (!preg_match('/^"(\\\\"|[^"])+"$/',
		             str_replace("\\\\","",$local)))
		         {
		            $isValid = false;
		         }
		      }
		      if ($isValid && !(checkdnsrr($domain,"MX") || 
					 checkdnsrr($domain,"A")))
		      {
		         // domain not found in DNS
		         $isValid = false;
		      }
		   }
		   
		  if($isValid == true)
		   echo 'true';
		   
		  if($isValid == false)
		   echo 'false';
		}
		
	mysql_close();
		
	
?>
 