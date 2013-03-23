

<?php
///add the new register coupon, also add notificaiton if possible


require("connect.php");

$couponID = $_GET['couponID'];
$productName = $_GET['productName'];
$productDescription = $_GET['productDescription'];
$productCategory = $_GET['productCategory']; //type of discout
$productPrice = $_GET['productPrice'];
$productImage = $_GET['productImage'];

$discountDescription = $_GET['discountDescription'];
$discountType = $_GET['discountType'];
$discountValue = $_GET['discountValue'];

$fromDate = $_GET['fromDate'];
$toDate = $_GET['toDate'];

$shop = $_GET['shop'];

$queryGet = mysql_query("SELECT locationID FROM Location WHERE name = '$shop' ");
if (!$queryGet) {
	 die('Could not query:' . mysql_error());
}
$rowID = mysql_fetch_row($queryGet);	
$shopID = $rowID[0];
$fromDate = $_GET['fromDate'];
$toDate = $_GET['toDate'];


$queryInsert =mysql_query( "INSERT INTO Coupon (productName,productDescription,productCategory,productPrice,productImage,discountDescription,discountType,discountValue,fromDate,toDate,shopID,barcode) VALUES ('$productName','$productDescription','$productCategory','$productPrice','$productImage','$discountDescription','$discountType','$discountValue','$fromDate','$toDate','$shopID','http://phptest.isaac.nl/iphone/coupons/barcode01.png') " ) ;
		
if (!$queryInsert) {
	 die('Could not query:' . mysql_error());
}

echo 'insert sucess, now insert push notification';	

//now loop through device token in subscription table where shopID and category match this new coupon, add it to notification table
$querySelect =mysql_query("SELECT * FROM Subscription WHERE shopID ='$shopID' AND productCategory = '$productCategory' ");
if (!$querySelect) {
	 die('Could not query:' . mysql_error());
}

while($row = mysql_fetch_array($querySelect)){
	$token = $row['token'];
	
	$queryInsert =mysql_query( "INSERT INTO Notification (id,token,shopID,couponID,productCategory,pushedDate) VALUES ('','$token','$shopID','$couponID','$productCategory','$fromDate') " ) ;
	if (!$queryInsert) {
		 die('Could not query:' . mysql_error());
	}

}


	echo '<form name="input" action="coupon-push.php" method="get">';
	echo '</br> Push notification to the app?';
	echo '<input type="submit" value="Push" />';
	echo '</form>';
	
?>


