  //
//  AugmentedRealityISAACAppDelegate.h
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 22-04-10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomUITabbarViewController.h"

#if !TARGET_IPHONE_SIMULATOR
#import "WikitudeARViewController.h"
#import "ARMenuButtonExit.h"
#endif

@class User;
@class Location;
@class LoadingEffectView;

@interface AugmentedRealityISAACAppDelegate : NSObject <UIApplicationDelegate, 
														UITabBarControllerDelegate, 
														CLLocationManagerDelegate,
														UIAlertViewDelegate
#if !TARGET_IPHONE_SIMULATOR 
,WikitudeARViewControllerDelegate
#endif
														> 
{
    UIWindow *window;
	UIImageView *waitingImage;
    UITabBarController *tabBarController;
	
	//var for location and user
	NSMutableArray *locationArray;
	NSMutableArray *subscriptionArray;
	NSMutableArray *notificationCouponArray;
	NSMutableArray *notificationLocationArray;
	NSMutableArray *couponArray;
	CLLocationManager *locationManager;
	NSInteger numberOfNewCoupon;
	User *user;
    NSMutableData *dataReceivedInJSON ;
	NSMutableDictionary *userInformationDict;
	
	BOOL simulateLocationOn;
	
	UIViewController *viewControllerThatActivateTheCamera;
	
	LoadingEffectView *loadingEffectView;
	
#if !TARGET_IPHONE_SIMULATOR
	WikitudeARViewController *wikitudeAR;
#endif
}

													

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIImageView *waitingImage;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) NSMutableArray *locationArray;
@property (nonatomic,retain) NSMutableArray *subscriptionArray;
@property (nonatomic,retain) NSMutableArray *notificationCouponArray;
@property (nonatomic,retain) NSMutableArray *notificationLocationArray;
@property (nonatomic,retain) NSMutableArray *couponArray;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSMutableDictionary *userInformationDict;
@property (nonatomic, assign) NSInteger numberOfNewCoupon;

//wikitude
-(void) addThePOIS;
-(void)turnCameraOn:(UIViewController *)fromViewController ;
												
//new API
-(void)ICS_startLoadingEffectWithMessage:(NSString *)message;
-(void)ICS_stopLoadingEffect;
-(void)ICS_sendPushNotificationRegisterAndEmailToServer;

-(void)ICS_sendMethodLoadSubscription;
-(void)ICS_sendMethodRegisterSubscriptionToShop:(NSInteger )shopID withCategory:(NSString *)productCategory withSubscribeOrUnsubscribe:(NSString *)yesOrNo;
-(BOOL)ICS_checkTheSubscriptionOfShop:(NSInteger)shopID andProductCategory:(NSString *)productCategory;
-(void)ICS_addSubscriptionOfShop:(NSInteger)shopID andProductCategory:(NSString *)productCategory;
-(void)ICS_removeSubscriptionOfShop:(NSInteger)shopID andProductCategory:(NSString *)productCategory;

-(void)ICS_sendMethodLoadNotification;
-(void)ICS_sendMethodLoadLocationsAroundUser:(User *)aUser;
-(void)ICS_sendMethodLoadLocationFromCouponID:(NSInteger)couponID;
-(void)ICS_loadLocationFromJsonData:(NSArray *)jsonArray;
-(void)ICS_loadCouponFromJsonData:(NSArray *)jsonArray andLocation:(Location *)location;

-(NSMutableDictionary *)ICS_readPlistFile:(NSString *)fileName;
-(BOOL)ICS_writePlistFile:(NSString *)fileName withData:(NSMutableDictionary *)dataDict;

-(void)ICS_sendSignedOffDateWithCouponID:(NSInteger )couponID;

-(void)ICS_validateLoadData;
-(NSString *)ICS_getLocationNameFromID:(NSInteger)locationID;
-(Location *)ICS_getLocationFromID:(NSInteger )locationID;
-(double)ICS_getDistanceToUserLocationFromLatitude:(double)latitude andLongitude:(double)longitude;

-(BOOL)ICS_validateEmail:(NSString *)emailString;


@end
