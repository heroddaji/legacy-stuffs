<?php
	
	require("connect.php");
	
	//get local time zone
	date_default_timezone_set('Europe/Amsterdam');
	echo date( 'Y-m-d H:i:s', time() );
	echo '</br>';
	//read coupon table
	$querySelect = mysql_query("SELECT * FROM Coupon ");
	if (!$querySelect) {
	  die('Could not query:' . mysql_error());
	}
	
	$queryShop = mysql_query("SELECT * FROM Location where type = 'shop' ");
	if (!$queryShop) {
	  die('Could not query:' . mysql_error());
	}
	
	$categoryArray = array();
	$shopArray = array();
	
	while($row = mysql_fetch_array($querySelect)){
		array_push($categoryArray,$row['category']);	
	}
	
	while($row2 = mysql_fetch_array($queryShop)){
		array_push($shopArray,$row2['name']);	
	}
	
	$queryMax = mysql_query("SELECT MAX(couponID) FROM Coupon");
	if (!$queryMax) {
	  die('Could not query:' . mysql_error());
	}

	$row3 = mysql_fetch_row($queryMax);
		
	$couponID = $row3[0] + 1;
	//echo $couponID;
	


	echo '<form name="input" action="coupon-add.php" method="get">';
	
	echo 'ID: <input type="text" name="couponID" value="'.$couponID.'" />';
	echo '</br>';
	
	echo 'Product name: <input type="text" name="productName" value="iPhone 4" />';
	echo '</br>';
	
	echo 'Product description: <input type="text" name="productDescription" value="iphone 4 is expensive" /> ';
	echo '</br>';
	echo 'Product category: <input type="text" name="productCategory" value="Mobile" /> ';
	//get list of category here
	echo '</br>';
	
	echo 'Product price: <input type="text" name="productPrice" value="600" /> ';
	echo '</br>';
	
	echo 'Product Image: <input type="text" name="productImage" value="any link here" /> ';
	echo '</br>';
	
	echo 'Discount description: <input type="text" name="discountDescription" value="20% discount" /> ';
	echo '</br>';
	
	echo 'Discount type';
	echo '<select name="discountType">';
		echo '<option value="percentage">percentage</option>';
		echo '<option value="absolute off">absolute off</option>';
		echo '<option value="absolute value">absolute value</option>';
	echo '</select>';
	echo '</br>';
	
	echo 'Discount value: <input type="text" name="discountValue" value="0.3" />';
	echo '</br>';
	
	echo 'this coupon will belong to shop: ';
	echo '<select name="shop">';
		
		for ($i=0; $i < count($shopArray);$i++){
			echo '<option value="'.$shopArray[$i].'">'.$shopArray[$i].'</option>'; 
		}
		
	echo '</select>';
	echo '</br>	';
	echo 'from Date : <input type="text" name="fromDate" value="'.date( 'Y-m-d H:i:s', time() ).'" />';
	echo 'to Date : <input type="text" name="toDate" value="'.date( 'Y-m-d H:i:s', time()+3600*24*30 ).'" />';
	echo '</br>	';
	echo '<input type="submit" value="Submit" />';
	echo '</form>';
	
?>

<form name="input" action="coupon-push.php" method="get">
</br>
<input type="submit" value="Push" />
</form>
