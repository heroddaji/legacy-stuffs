//
//  AugmentedRealityISAACAppDelegate.m
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 22-04-10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

/* NOTE : WHEN USE JSON ENCODE
 * THE RETURN TYPE CAN BE SEE EASILY BE NSLOG WITH THE FIRST BRACKET TYPE
 * IF FOR EX: jsonDict: { ..     the bracket is curly with a litle sharp in middle
 *		THEN jsonDict is a dictionary
 * IF FOR EX: locArray: ( ..     the bracket is curly
 *		THEN locArray is an array
 */


#import "AugmentedRealityISAACAppDelegate.h"
#import "User.h"
#import "JSON.h"
#import "Location.h"
#import "Coupon.h"
#import "LocationViewController.h"
#import "loadingEffectView.h"
#import "Subscription.h"
#import "Notification.h"

#pragma mark privateMethod to overide the tabbar color
@interface UITabBar (ColorExtensions)
- (void)recolorItemsWithColor:(UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowBlur:(CGFloat)shadowBlur;
@end

@implementation UITabBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *myImage = [[UIImage imageNamed:@"tabbar_background.png"] retain];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
	
	//[self addSubview:imageView];
	[imageView release];
}
@end


@interface UITabBarItem (Private)
@property(retain, nonatomic) UIImage *selectedImage;
- (void)_updateView;
@end

@implementation UITabBar (ColorExtensions)
- (void)recolorItemsWithColor:(UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowBlur:(CGFloat)shadowBlur
{
	/*UIImage *myImage = [[UIImage imageNamed:@"tabbar_background.png"] retain];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
	imageView.alpha = 0.9;
	imageView.opaque = YES;
	[self addSubview:imageView];
	[imageView release];
	*/
	
    CGColorRef cgColor = [color CGColor];
    CGColorRef cgShadowColor = [shadowColor CGColor];
    for (UITabBarItem *item in [self items])
        if ([item respondsToSelector:@selector(selectedImage)] &&
            [item respondsToSelector:@selector(setSelectedImage:)] &&
            [item respondsToSelector:@selector(_updateView)])
        {
            CGRect contextRect;
            contextRect.origin.x = 0.0f;
            contextRect.origin.y = 0.0f;
            contextRect.size = [[item selectedImage] size];
            // Retrieve source image and begin image context
            UIImage *itemImage = [item image];
            CGSize itemImageSize = [itemImage size];
            CGPoint itemImagePosition; 
            itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
            itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) / 2);
            UIGraphicsBeginImageContext(contextRect.size);
            CGContextRef c = UIGraphicsGetCurrentContext();
            // Setup shadow
            CGContextSetShadowWithColor(c, shadowOffset, shadowBlur, cgShadowColor);
            // Setup transparency layer and clip to mask
            CGContextBeginTransparencyLayer(c, NULL);
            CGContextScaleCTM(c, 1.0, -1.0);
            CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [itemImage CGImage]);
            // Fill and end the transparency layer
            CGContextSetFillColorWithColor(c, cgColor);
            contextRect.size.height = -contextRect.size.height;
            CGContextFillRect(c, contextRect);
            CGContextEndTransparencyLayer(c);
            // Set selected image and end context
            [item setSelectedImage:UIGraphicsGetImageFromCurrentImageContext()];
            UIGraphicsEndImageContext();
            // Update the view
            [item _updateView];
        }
}
@end



@implementation AugmentedRealityISAACAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize waitingImage;

@synthesize locationManager;
@synthesize locationArray;
@synthesize subscriptionArray;
@synthesize notificationCouponArray;
@synthesize notificationLocationArray;
@synthesize couponArray;
@synthesize user;
@synthesize userInformationDict;
@synthesize numberOfNewCoupon;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	NSLog(@"application didFinishLaunchingWithOptions");
	
	waitingImage= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
	[window addSubview:waitingImage];
	[window makeKeyAndVisible];
	[self ICS_startLoadingEffectWithMessage:@"Loading discounts..."];
	
	tabBarController.delegate = self;
	[[tabBarController tabBar] recolorItemsWithColor:[UIColor whiteColor] shadowColor:[UIColor blueColor] shadowOffset:CGSizeMake(0.0f, -1.0f) shadowBlur:2.0f];
	
	
	//register device token
    [[UIApplication sharedApplication] 
	 registerForRemoteNotificationTypes:
	 (UIRemoteNotificationTypeAlert | 
	  UIRemoteNotificationTypeBadge | 
	  UIRemoteNotificationTypeSound)];

	// read the userinformation file and store all info into those dict and array	
	userInformationDict = [[NSMutableDictionary alloc]initWithDictionary:[self ICS_readPlistFile:@"UserInformation"]];
	dataReceivedInJSON = [[NSMutableData data] retain];
	locationArray = [[NSMutableArray alloc]init];
	subscriptionArray = [[NSMutableArray alloc]init];
	notificationCouponArray = [[NSMutableArray alloc]init];
	notificationLocationArray = [[NSMutableArray alloc]init];
	couponArray = [[NSMutableArray alloc]init];
	
	user = [[User alloc]init];
	user.name = @"You are here";
	//user.shortDescription = @"You are here!";
	user.radius = 20000;
	
	numberOfNewCoupon = 0;
	
		
#if !TARGET_IPHONE_SIMULATOR

	locationManager = [[CLLocationManager alloc]init];
	
	if (locationManager.locationServicesEnabled == NO) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service" 
														message:@"Please enable Location service in your setting to use the application.This application will exit in a few seconds" 
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[self performSelector:@selector(quitAppIfLocationServiceIsNotEnable) withObject:nil afterDelay:7];
	}
	
	else if (locationManager.locationServicesEnabled == YES) {
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		[locationManager startUpdatingLocation];
	}
	
#endif
	
#if TARGET_IPHONE_SIMULATOR
	
	user.latitude = 51.4305215;
	user.longitude = 5.48458274;
	
	//LOAD info from server
	[self ICS_sendMethodLoadNotification];
	[self ICS_sendMethodLoadSubscription];
	[self ICS_sendMethodLoadLocationsAroundUser:user];
	[self ICS_validateLoadData];
	
	NSLog(@"finishLoading all data...");
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCheckServerLoadingStatus:) userInfo:nil repeats:YES];
	
#endif
	 
	//set application badge numner
	application.applicationIconBadgeNumber = 0;
	
	
	return YES; 	
}

-(void)quitAppIfLocationServiceIsNotEnable{
	[self applicationWillTerminate:[UIApplication sharedApplication]];
}

-(void)timerCheckServerLoadingStatus:(NSTimer *)theTimer{
	
	NSLog(@"timerCheckServerLoadingStatus...");
	if ([locationArray count]>0) {
		NSLog(@"loading done");
		[theTimer invalidate];
		
		[self ICS_stopLoadingEffect];
		
		[window addSubview:tabBarController.view];
		[waitingImage removeFromSuperview];
		
		if ([notificationCouponArray count]>0) {
			tabBarController.selectedIndex = 2;//3 is the tabbar for coupon		
		}
		
	}
	
}

#if !TARGET_IPHONE_SIMULATOR

#pragma mark PUSH notifications delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken { 
	

	
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
    NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];

    // Set the defaults to disabled unless we find otherwise...
    NSString *pushBadge = @"disabled";
    NSString *pushAlert = @"disabled";
    NSString *pushSound = @"disabled";
	
    // Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
    // one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the
    // single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be
    // true if those two notifications are on.  This is why the code is written this way
	
    if(rntypes == UIRemoteNotificationTypeBadge){
        pushBadge = @"enabled";
    }
    else if(rntypes == UIRemoteNotificationTypeAlert){
        pushAlert = @"enabled";
    }
    else if(rntypes == UIRemoteNotificationTypeSound){
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)){
        pushBadge = @"enabled";
        pushAlert = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)){
        pushBadge = @"enabled";
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
    else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
        pushBadge = @"enabled";
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
	
	[userInformationDict setValue:pushAlert forKey:@"pushAlert"];
	[userInformationDict setValue:pushBadge forKey:@"pushBadge"];
	[userInformationDict setValue:pushSound forKey:@"pushSound"];
	
	// Get the device token
    NSString *deviceTokenStr = [[[[deviceToken description]
							   stringByReplacingOccurrencesOfString:@"<"withString:@""]
							  stringByReplacingOccurrencesOfString:@">" withString:@""]
							 stringByReplacingOccurrencesOfString: @" " withString: @""];
	
    NSLog(@"%@",deviceTokenStr);
	[userInformationDict setValue:deviceTokenStr forKey:@"token"];
	
	
	[self ICS_sendPushNotificationRegisterAndEmailToServer];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
    NSString *str = [NSString stringWithFormat: @"didFailToRegisterForRemoteNotificationsWithError: %@", err];
    NSLog(@"%@",str); 
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }    
	
}

#endif

#pragma mark GENERAL API FOR THIS APP 

//ICS API

-(void)ICS_startLoadingEffectWithMessage:(NSString *)message{
	
	[NSThread detachNewThreadSelector:@selector(ICS_showLoadingEffect:) toTarget:self withObject:message];
	
	/*
	 NSString *theMessage;
	
	if (message == nil) {
		theMessage = @"Loading...";
	}
	else {
		theMessage = message;
	}

	
	loadingEffectView = [[LoadingEffectView alloc] initWithNibName:@"LoadingEffectView" bundle:nil];
	loadingEffectView.message = theMessage;
	
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(fromView.frame.size.width/2 - loadingEffectView.view.frame.size.width/2,fromView.frame.size.height/2 - loadingEffectView.view.frame.size.height/2);
	[loadingEffectView.view setTransform:myTransform];
	
	[fromView addSubview:loadingEffectView.view];
	 
	 */
}

-(void)ICS_showLoadingEffect:(NSString *)message{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSString *theMessage;
	
	if (message == nil) {
		theMessage = @"Loading...";
	}
	else {
		theMessage = message;
	}
	
	
	//loadingEffectView = [[LoadingEffectView alloc] initWithNibName:@"LoadingEffectView" bundle:nil];
	loadingEffectView = [[LoadingEffectView alloc] init];
	
	loadingEffectView.message = theMessage;
	
	UIView *fromView = window;
	
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(fromView.frame.size.width/2 - loadingEffectView.view.frame.size.width/2,fromView.frame.size.height/2 - loadingEffectView.view.frame.size.height/2-50);
	[loadingEffectView.view setTransform:myTransform];
	
	@synchronized(fromView){
		[fromView addSubview:loadingEffectView.view];
	}
	[pool drain];
}

-(void)ICS_stopLoadingEffect{
	[((EffectView *)loadingEffectView.view) removeView];
	[loadingEffectView.view removeFromSuperview];
}

-(void)ICS_sendPushNotificationRegisterAndEmailToServer{
	if ([self ICS_writePlistFile:@"UserInformation" withData:userInformationDict] == YES) {
		
		NSString *token = [userInformationDict valueForKey:@"token"];
		NSString *email = [userInformationDict valueForKey:@"email"];
		#if TARGET_IPHONE_SIMULATOR
		token = @"1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9";
		email = @"simulation@yahoo.com";
		#endif
		
		NSString *urlRequestString = 
		[NSString stringWithFormat:@"http://localhost/dai/phpfile.php?method=2&token=%@&email=%@&pushAlert=%@&pushBadge=%@&pushSound=%@",
		 token,email,[userInformationDict valueForKey:@"pushAlert"],[userInformationDict valueForKey:@"pushBadge"],[userInformationDict valueForKey:@"pushSound"]];
		
		NSURL *url = [NSURL URLWithString:urlRequestString];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSLog(@"Register URL: %@", url);
		NSLog(@"Return Data: %@", returnData);	
	}
	else {
		NSLog(@"cannot write to plist file");
	}	
}

-(void)ICS_sendMethodLoadNotification{
	NSLog(@"ICS_sendMethodLoadNotification");
	
	[notificationCouponArray removeAllObjects];
	
	NSString *token = [userInformationDict valueForKey:@"token"];
	#if TARGET_IPHONE_SIMULATOR
	token = @"1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9";
	#endif
	
	
	NSString  *urlRequestString = [NSString stringWithFormat:@"http://localhost/dai/phpfile.php?method=5&token=%@",token];
	NSError *errorDesc = nil;
	
	//send request synschronously
	NSURL *url = [NSURL URLWithString:urlRequestString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorDesc];
	NSString *responseString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
	NSDictionary *jsonDict = [responseString JSONValue];
	NSArray *jsonArray = [jsonDict objectForKey:@"locArray"];
	
	//add to userinformationdict
	[notificationCouponArray removeAllObjects];
	for (NSDictionary *dict in jsonArray) {
		
		Notification *aNoti = [[Notification alloc] init];
		aNoti.couponID = [[dict objectForKey:@"couponID"] integerValue];
		aNoti.shopID = [[dict objectForKey:@"shopID"] integerValue];
		
		[notificationCouponArray addObject:aNoti];
		
		[aNoti release];
	}
	
	[responseString release];
}


-(void)ICS_sendMethodLoadSubscription{
	NSLog(@"ICS_sendMethodLoadSubscription");
	
	[subscriptionArray removeAllObjects];
	
	NSString *token = [userInformationDict valueForKey:@"token"];
	#if TARGET_IPHONE_SIMULATOR
	token = @"1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9";
	#endif
	
	NSString  *urlRequestString = [NSString stringWithFormat:@"http://localhost/dai/phpfile.php?method=4&token=%@",token];
	NSError *errorDesc = nil;
	
	//send request synschronously
	NSURL *url = [NSURL URLWithString:urlRequestString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorDesc];
	NSString *responseString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
	NSDictionary *jsonDict = [responseString JSONValue];
	NSArray *jsonArray = [jsonDict objectForKey:@"locArray"];
	
	//load subscriptions
	for (NSDictionary *dict in jsonArray) {
		
		Subscription *aSub = [[Subscription alloc] init];
		aSub.shopID = [[dict objectForKey:@"shopID"] integerValue];
		aSub.productCategory = [dict objectForKey:@"productCategory"];
		
		[subscriptionArray addObject:aSub];
		
		[aSub release];
	}
	
	[responseString release];
}

-(void)ICS_sendMethodRegisterSubscriptionToShop:(NSInteger )shopID withCategory:(NSString *)productCategory withSubscribeOrUnsubscribe:(NSString *)yesOrNo{
	
	NSString *token = [userInformationDict valueForKey:@"token"];
	
#if TARGET_IPHONE_SIMULATOR	
	token = @"1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9";
#endif
	
	NSString *urlRequestString = 
	[NSString stringWithFormat:@"http://localhost/dai/phpfile.php?method=3&token=%@&shopID=%d&productCategory=%@&subscribe=%@",token,shopID,productCategory,yesOrNo];
	
	NSURL *url = [NSURL URLWithString:urlRequestString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSLog(@"Register URL: %@", url);
	NSLog(@"Return Data: %@", returnData);	
	
}

-(BOOL)ICS_checkTheSubscriptionOfShop:(NSInteger)shopID andProductCategory:(NSString *)productCategory{
	NSLog(@"ICS_checkTheSubscriptionOfShop: %d andProductCategory: %@",shopID,productCategory);
	
	for (Subscription *aSub in subscriptionArray) {
		if (aSub.shopID == shopID && [aSub.productCategory isEqualToString:productCategory]) {
			NSLog(@"found the subscription");
			return YES;
		}
	}
	
	NSLog(@"do not found the subscription");
	return NO;
}

-(void)ICS_addSubscriptionOfShop:(NSInteger)shopID andProductCategory:(NSString *)productCategory{
	NSLog(@"ICS_addSubscriptionOfShop: %d andProductCategory: %@",shopID,productCategory);
	
		if ([self ICS_checkTheSubscriptionOfShop:shopID andProductCategory:productCategory] == NO) {
			Subscription *aSub = [[Subscription alloc] init];
			aSub.shopID = shopID;
			aSub.productCategory = productCategory;
			
			[subscriptionArray addObject:aSub];
			
			[aSub release];
			NSLog(@"add new subscription success");
		}
		else {
			NSLog(@"subscription already exist, will not add");
		}

}

-(void)ICS_removeSubscriptionOfShop:(NSInteger)shopID andProductCategory:(NSString *)productCategory{
	NSLog(@"ICS_removeSubscriptionOfShop: %d andProductCategory: %@",shopID,productCategory);
	
	int count = 0;
	for (Subscription *aSub in subscriptionArray) {
		if (aSub.shopID == shopID && [aSub.productCategory isEqualToString:productCategory]) {
			
			[subscriptionArray removeObjectAtIndex:count];
			
			NSLog(@"remove the subscription sucessfull");
			return ;
		}
		count++;
	}
	
	NSLog(@"can't find the subscription to remove");
}


-(void)ICS_sendMethodLoadLocationsAroundUser:(User *)aUser{
	NSLog(@"ICS_sendMethodLoadLocationsAroundUser");
	
	[locationArray removeAllObjects];
	
	NSString *urlRequestString = [NSString stringWithFormat:@"http://localhost/dai/phpfile.php?method=1&userLatitude=%1.7f&userLongitude=%1.7f&userRadius=%1.7f",aUser.latitude,aUser.longitude,aUser.radius];
	NSLog(@"%@",urlRequestString);
	
	NSError *errorDesc = nil;
	
	//send request synschronously
	NSURL *url = [NSURL URLWithString:urlRequestString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorDesc];
	NSString *responseString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
	
	//MUST RETAIN THIS JSONDICT, DONT KNOW WHY IT GOT AUTO RELEASE VERY FAST
	NSDictionary *jsonDict = [[responseString JSONValue] retain];
	
	NSArray *jsonArray = [jsonDict objectForKey:@"locArray"];
	
	[self ICS_loadLocationFromJsonData:jsonArray];
		
	[responseString release];
}

-(void)ICS_loadLocationFromJsonData:(NSArray *)jsonArray{
	NSLog(@"ICS_loadLocationFromJsonData");
	
	for (int i = 0; i < [jsonArray count];i++) {
		
		//THIS PART OF CODE IS WORKED FOR IOS 3.1.3, BUT NOT FOR IOS 4.0, BECAUSE EACH OBJECT IN JSON ARRAY SWITCH TO NSDICTIONARY INSTEAD OF NSARRAY
		/*
		NSArray *locObject = [[NSArray alloc]initWithArray:[jsonArray objectAtIndex:i] ];
		
		Location *loc = [[Location alloc]init];
		
		loc.phone = [locObject objectAtIndex:0];
		loc.url = [locObject objectAtIndex:1];
		loc.addressHint = [locObject objectAtIndex:2];
		loc.name = [locObject objectAtIndex:3];
		loc.email = [locObject objectAtIndex:4];
		NSString *idS = (NSString *)[locObject objectAtIndex:6];
		loc.ID = [idS integerValue];
		loc.type = [locObject objectAtIndex:7];
		loc.shortDescription = [locObject objectAtIndex:8];
		loc.latitude = [[locObject objectAtIndex:9] doubleValue];
		loc.longitude = [[locObject objectAtIndex:10] doubleValue];
		
		NSString *str = [loc.name lowercaseString];
		str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		
		//json coupons array 
		NSArray *couponObject = [locObject objectAtIndex:5] ;
		[self ICS_loadCouponFromJsonData:couponObject andLocation:loc];		
		
		[locationArray addObject:loc];
		
		[loc release];
		[locObject release];
		 */
		
		NSDictionary *locObject = [jsonArray objectAtIndex:i];
		
		Location *loc = [[Location alloc]init];
		
		loc.phone = [locObject objectForKey:@"phone"];
		loc.url = [locObject objectForKey:@"homepageURL"];
		loc.addressHint = [locObject objectForKey:@"addressHint"];
		loc.name = [locObject objectForKey:@"name"];
		loc.email = [locObject objectForKey:@"email"];
		loc.ID = [[locObject objectForKey:@"locationID"] integerValue];
		loc.type = [locObject objectForKey:@"type"];
		loc.shortDescription = [locObject objectForKey:@"description"];
		loc.latitude = [[locObject objectForKey:@"latitude"] doubleValue];
		loc.longitude = [[locObject objectForKey:@"longitude"] doubleValue];
		
		//json coupons array 
		
		
		NSArray *couponObject = [locObject objectForKey:@"coupons"];
		
		[self ICS_loadCouponFromJsonData:couponObject andLocation:loc];		
		NSLog(@"locID and name:%d %@",loc.ID,loc.name);
		[locationArray addObject:loc];
		
		[loc release];
		[locObject release];
		
	}

	#if !TARGET_IPHONE_SIMULATOR
	//add the POI to camera
	[self addThePOIS];
	#endif
}

-(void)ICS_loadCouponFromJsonData:(NSArray *)jsonArray andLocation:(Location *)location{
	NSLog(@"ICS_loadCouponFromJsonData");
	
	for (int i = 0; i <[jsonArray count]; i++) {
		
		//get each coupon in the coupon array;
		NSDictionary *eachCouponObject = [jsonArray objectAtIndex:i] ;
		
		//now alloc new coupon and get data
		Coupon *theCou = [[Coupon alloc]init];
		
		theCou.productName = [eachCouponObject objectForKey:@"productName"];
		theCou.productDescription = [eachCouponObject objectForKey:@"productDescription"];
		theCou.productCategory = [eachCouponObject objectForKey:@"productCategory"];
		theCou.productBrand = [eachCouponObject objectForKey:@"productBrand"];
		theCou.productPrice =[[eachCouponObject objectForKey:@"productPrice"] floatValue];
		theCou.productImage = [eachCouponObject objectForKey:@"productImage"];
		
		theCou.couponID = [[eachCouponObject objectForKey:@"couponID"] integerValue];
		theCou.discountDescription = [eachCouponObject objectForKey:@"discountDescription"];
		theCou.discountType = [eachCouponObject objectForKey:@"discountType"];
		theCou.discountValue = [[eachCouponObject objectForKey:@"discountValue"] floatValue];
		theCou.barcode = [eachCouponObject objectForKey:@"barcode"];
		theCou.fromDate = (NSDate *)[eachCouponObject objectForKey:@"fromDate"];
		theCou.toDate = (NSDate *)[eachCouponObject objectForKey:@"toDate"];
		theCou.shopID = [[eachCouponObject objectForKey:@"shopID"] integerValue];
		theCou.remainDays = [[eachCouponObject objectForKey:@"remainDays"] integerValue];
		
		[location.coupons addObject:theCou];
		[theCou release];
	}
	
}

-(void)ICS_validateLoadData{
	NSLog(@"ICS_validateLoadData");
	
	BOOL foundCouponNotInCurrentLocationArray = NO;
	
	if ([notificationCouponArray count] > 0) {
		
		for (Notification *noti in notificationCouponArray) {
			
			Location *loc = [self ICS_getLocationFromID:noti.shopID];
			
			//if location is not nil, mean new coupon is in the locationArray list
			if (loc != nil) {
				
				Coupon *cou = [loc getCouponByID:noti.couponID];
				if (cou != nil) {
					cou.status = @"new";
				}
			}
			
			//if location is nil, mean new coupon is not in the locationArray list, then have to download that new location
			if (loc == nil) {
				[self ICS_sendMethodLoadLocationFromCouponID:noti.couponID];
				foundCouponNotInCurrentLocationArray = YES;
			}
		}
	}
	
	//check again
	if (foundCouponNotInCurrentLocationArray == YES) {
		[self ICS_validateLoadData];
	}
}

-(void)ICS_sendMethodLoadLocationFromCouponID:(NSInteger)couponID{
	NSLog(@"loadLocationWithCouponID:%d",couponID);
	NSString  *urlRequestString = [NSString stringWithFormat:@"http://localhost/dai/phpfile.php?method=6&couponID=%@",couponID];
	NSError *errorDesc = nil;
	
	//send request synschronously
	NSURL *url = [NSURL URLWithString:urlRequestString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorDesc];
	///[NSURLConnection connectionWithRequest:request delegate:[[Method6Delegate init] alloc]]
	NSString *responseString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
	NSDictionary *jsonDict = [responseString JSONValue];
	NSArray *jsonArray = [jsonDict objectForKey:@"locArray"];
	
	[self ICS_loadLocationFromJsonData:jsonArray];
	
	[responseString release];
}

-(void)ICS_sendSignedOffDateWithCouponID:(NSInteger )couponID{
	
	NSString *token = [userInformationDict valueForKey:@"token"];
	
	#if TARGET_IPHONE_SIMULATOR
	token = @"1d02bbd578ae8b59000b00344546d491b3b53523deb796a41f2db91651056da9";
	//email = @"simulation@yahoo.com";
	#endif
	
	NSString  *urlRequestString = [NSString stringWithFormat:@"http://localhost/dai/phpfile.php?method=7&token=%@&couponID=%d",token,couponID];
	NSError *errorDesc = nil;
	
	//send request synschronously
	NSURL *url = [NSURL URLWithString:urlRequestString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorDesc];
	NSLog(@"request:%@",urlRequestString);
	NSLog(@"return Data:%@",[returnData description]);
	
	numberOfNewCoupon = numberOfNewCoupon - 1;
}

-(NSMutableDictionary *)ICS_readPlistFile:(NSString *)fileName{
	
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															  NSUserDomainMask, YES) objectAtIndex:0];
	NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
	}
	NSLog(@"%@",plistPath);
	
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSMutableDictionary *plistDict = (NSMutableDictionary *)[NSPropertyListSerialization
															 propertyListFromData:plistXML
															 mutabilityOption:NSPropertyListMutableContainersAndLeaves
															 format:&format
															 errorDescription:&errorDesc];
	if (!plistDict) {
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
	
	return plistDict;
}

-(BOOL)ICS_writePlistFile:(NSString *)fileName withData:(NSMutableDictionary *)dataDict{
	
	NSString *error;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *plistPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
	NSLog(@"%@",plistPath);
	//[plistDict setValue:@"token change" forKey:@"token"];
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dataDict
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
	if(plistData) {
		[plistData writeToFile:plistPath atomically:YES];
	}
	else {
		NSLog(@"erroe %@",error);
		[error release];
		return NO;
	}
	return YES;
}

-(double)ICS_getDistanceToUserLocationFromLatitude:(double)latitude andLongitude:(double)longitude{
	NSLog(@"ICS_getDistanceToUserLocationFromLatitude");
	
	CLLocation *userLocationCoordinate = [[[CLLocation alloc] initWithLatitude:user.coordinate.latitude 
																	 longitude:user.coordinate.longitude] autorelease];
	
	CLLocation *cellLocationCoordinate = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
	
	return [userLocationCoordinate distanceFromLocation:cellLocationCoordinate];
}

-(NSString *)ICS_getLocationNameFromID:(NSInteger)locationID{
	for (Location *loc in locationArray) {
		if (loc.ID == locationID) {
			return loc.name;
		}
	}
	return @"can't find the name";
}

-(Location *)ICS_getLocationFromID:(NSInteger)locationID{
	NSLog(@"ICS_getLocationFromID:%d",locationID);
	
	for (Location *loc in locationArray) {
		if (loc.ID == locationID) {
			return loc;
		}
	}
	
	return nil;
}

-(BOOL)ICS_validateEmail:(NSString *)emailString{
	NSLog(@"ICS_validateEmail");
	
	//IF VALID EMAIL, ALSO REGISTER AT THE SERVER, AND RETURN YES
	//ELSE RETURN NO
	
	/*
	//----------- EASY CHECK WITH REGEX -------
	//this code validate mail by regulation express (regex)
	NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx]; 
	//Valid email address 
	if ([emailTest evaluateWithObject:emailString] == YES) 
	{
		return YES;
	} 
	else {
		//Invalid email address 
		return NO;
	}
	return YES;
	*/
	
	//--------ADVANCE CHECK BY SEND INFO TO SERVER ----
	
	//first check if new enteremail is the same as old email
	
	if (emailString == nil) {
		NSLog(@"email is nil");
		return NO;
	}
	
	else if ([emailString isEqualToString:@"" ]) {
		NSLog(@"email is empty");
		return NO;
	}
	
	else if ([emailString isEqualToString:[userInformationDict objectForKey:@"email"]]) {
		
		NSLog(@"enter same email, not check");
		return YES;
	}
	
	
	
	//if not , validate new email
	[self ICS_startLoadingEffectWithMessage:@"Validating email..."];
	
	NSString  *urlRequestString = [NSString stringWithFormat:@"http://localhost/dai/phpfile.php?method=8&email=%@",emailString];
	NSError *errorDesc = nil;
	
	NSURL *url = [NSURL URLWithString:urlRequestString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errorDesc];
	NSLog(@"request:%@",urlRequestString);
	
	NSString *resultString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"return Data:%@",resultString);
	
	[self ICS_stopLoadingEffect];
	
	
	if ([resultString rangeOfString:@"false"].length > 0) {
		//Invalid email
		return NO;
	}
	
	if ([resultString rangeOfString:@"true"].length > 0) {
		//valide email
		//save and send to server new email
		
		[self.userInformationDict setValue:emailString forKey:@"email"];
		
		[NSThread detachNewThreadSelector:@selector(ICS_sendEmailToServer) toTarget:self withObject:nil];
		
		return YES;
	}
	
	return YES;

}

-(void)ICS_sendEmailToServer{

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self ICS_sendPushNotificationRegisterAndEmailToServer];
	
	[pool drain];
}

//END ICS API

#if !TARGET_IPHONE_SIMULATOR

#pragma mark WikitudeAR api
-(void)turnCameraOn:(UIViewController *)fromViewController{
	NSLog(@"turnCameraOn");
	
	[self ICS_startLoadingEffectWithMessage:@"na"];
	
	if (!wikitudeAR) {
		wikitudeAR = [[WikitudeARViewController alloc]initWithDelegate:self 
													applicationPackage:@"nl.isaac.AugmentedRealityISAAC" 
														applicationKey:@"E9CF70FA743B32ADE046922ABF60648A" 
													   applicationName:@"AugmentedRealityISAAC" 
														 developerName:@"dai tran hoang"];
	}
	else {
		[wikitudeAR show];
	}
	
	viewControllerThatActivateTheCamera = fromViewController;
	[viewControllerThatActivateTheCamera retain];
	
	[self performSelector:@selector(ICS_stopLoadingEffect) withObject:nil afterDelay:1];
}

- (void)actionFired:(WTPoi*)POI {
	NSLog(@"actionFired");
	
	//get the selected location by its coordinate
	Location *selectedLoc = [[Location alloc]init];
	
	for (Location *loc in locationArray) {
		if (loc.latitude == POI.latitude && loc.longitude == POI.longitude) {
			selectedLoc = loc;
			NSLog(@"get loc %@",[selectedLoc description]);
			break;
		}
	}
	
	LocationViewController *locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
	locationViewController.thisLocation = selectedLoc;
	locationViewController.isCameraOn = YES;
	
	[wikitudeAR hide];
	[viewControllerThatActivateTheCamera.navigationController pushViewController:locationViewController animated:NO];
	 
	
	
}

- (void)verificationDidSucceed {
	
	UIView *theView = [wikitudeAR start];
	[self.window addSubview:theView];
	NSLog(@"%d",[theView retainCount]);
	
}

- (void)verificationDidFail {
	NSLog(@"wikitude verifi fail");
}

- (void)didUpdateToLocation: (CLLocation*) newLocation
			   fromLocation: (CLLocation*) oldLocation {
	NSLog(@"update to location");
}

-(void) APIFinishedLoading {
	
	[self addThePOIS];
	
	[wikitudeAR setTitleText:@"title test"];
	[wikitudeAR setTitleBarImage:[UIImage imageNamed:@"shop-icon.png"]];
	[wikitudeAR printMarkerSubText:TRUE];
	
	//add some custome button
	ARMenuButtonExit* menuButtonExitDelegate = [[ARMenuButtonExit alloc] init];
	WikitudeARCustomMenuButton* menuButtonExit = [[WikitudeARCustomMenuButton alloc] initWithText:@"Exit" Delegate:menuButtonExitDelegate];
	[wikitudeAR addMenuItem:menuButtonExit atPosition:1];
	
}

-(void)addThePOIS{
	
	//after loaddata for the map, check if the camera is on, if on, load data for camera
	if (wikitudeAR != nil) {
		for (WTPoi *poi in [wikitudeAR getPOIs]) {
			[wikitudeAR removePOI:poi];
			
		}
		NSLog(@"wikitudeAR pois size: %d",[[wikitudeAR getPOIs] count]);
		
		
		//now add pois, this is hardcode
		NSArray *poiFromLocation = [[NSMutableArray alloc] initWithArray:locationArray]; 
		NSMutableArray* pois = [[NSMutableArray alloc] init];
		
		for (int i=0; i < [poiFromLocation count]; i++) {
			Location *thisLocation = (Location *)[poiFromLocation objectAtIndex:i]; 
			
			WTPoi* poi = [[WTPoi alloc] initWithName:thisLocation.name
										 AndLatitude:thisLocation.latitude
										AndLongitude:thisLocation.longitude];
			
			poi.shortDescription = thisLocation.shortDescription;
			poi.url = thisLocation.url;
			poi.icon = [NSString stringWithFormat:@"http://localhost/dai/icons/%@.png",thisLocation.type];
			poi.phone = thisLocation.phone;
			poi.thumbnail = [NSString stringWithFormat:@"http://localhost/dai/thumbnails/%@-thumbnail.jpeg",thisLocation.name];
			poi.email = thisLocation.email;
			
			[pois addObject:poi];
			[poi release];
		}
		
		[[WikitudeARViewController sharedInstance] addPOIs:pois];
		
		[pois release];
		[poiFromLocation release];
		
		NSLog(@"done camera add points");
	}
}
 
#endif

#pragma tabBarController
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	NSLog(@"shouldSelectViewController");
	
	/*
	
	//pop back to root view, avoid error like view 1 coupon at 2 tabs at the same time
	if ([viewController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *navCon = (UINavigationController *)viewController;
		[navCon popToRootViewControllerAnimated:NO];
	}
	*/
	return YES;
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	
	static int count = 0;
	if (count == 0) {
		//if first time update to gett user location, load all resource
		NSLog(@"locationManager didUpdateToLocation");
		
		user.latitude = newLocation.coordinate.latitude;
		user.longitude = newLocation.coordinate.longitude;
		
		//LOAD info from server
		[self ICS_sendMethodLoadNotification];
		[self ICS_sendMethodLoadSubscription];
		[self ICS_sendMethodLoadLocationsAroundUser:user];
		[self ICS_validateLoadData];
		
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCheckServerLoadingStatus:) userInfo:nil repeats:YES];
			
		count++;
	}
	else{
			
		if (oldLocation != nil) {
			//if other time, check the distance between old and new loccation, if distance more than 200 meters, the update the resouces again
			CLLocationDistance newDistance = [newLocation distanceFromLocation:oldLocation];
			
			if (newDistance > 200) {
				NSLog(@"locationManager user location change , update to newlocation");
				
				user.latitude = newLocation.coordinate.latitude;
				user.longitude = newLocation.coordinate.longitude;
				
				//LOAD info from server
				[self ICS_sendMethodLoadNotification];
				[self ICS_sendMethodLoadSubscription];
				[self ICS_sendMethodLoadLocationsAroundUser:user];
				[self ICS_validateLoadData];
				
				count++;
			}
			
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	NSLog(@"locationManager didFailWithError: %@",[error description]);
	
	[manager stopUpdatingLocation];
}

#pragma mark Multitasking
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
	
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
	
	//not support multitasking now
	//shouldn't use this code in applicationWillResignActive, because when location pop up ask for permisson, it will kill the app
	[self applicationWillTerminate:[UIApplication sharedApplication]];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   NSLog(@"applicationDidBecomeActive");
}



#pragma mark finishing app
- (void)applicationWillTerminate:(UIApplication *)application{
	NSLog(@"app will terminal");
	[self ICS_sendPushNotificationRegisterAndEmailToServer];
	application.applicationIconBadgeNumber = numberOfNewCoupon;
	
	exit(0);
}
 
- (void)dealloc {
	
	
	[dataReceivedInJSON release];
	[locationArray release];
	[subscriptionArray release];
	[notificationCouponArray release];
	[notificationLocationArray release];
	[couponArray release];
	[locationManager release];
	[user release];
	[viewControllerThatActivateTheCamera release];
	[loadingEffectView release];
	
	#if !TARGET_IPHONE_SIMULATOR
	[wikitudeAR release];
	#endif
	
	[tabBarController release];
	[waitingImage release];
	[window release];
	[super dealloc];
}

@end

