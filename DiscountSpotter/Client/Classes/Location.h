//
//  City.h
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 22-04-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Coupon.h"

@interface Location :NSObject <MKAnnotation> {
	
	NSInteger ID;
	NSString *name;
	NSString *shortDescription;
	NSString *type;
	NSString *addressHint;
	NSString *phone;
	NSString *url;
	NSString *email;
	
	// geographical data
	double latitude;
	double longitude;
		
	//coupons
	NSMutableArray *coupons;
	
	//this ivar only mean for coupons in the notificationArray
	NSMutableArray *notificationCoupons;
	
	//this ivar only mean for shop with subscription
	NSMutableArray *subscriptionCategories;
}
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,retain) NSString *addressHint;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *shortDescription;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic, retain) NSMutableArray *coupons;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *email;

@property (nonatomic, retain) NSMutableArray *subscriptionCategories;
@property (nonatomic, retain) NSMutableArray *notificationCoupons;

-(id)initWithLocation:(Location *)loc;
-(Coupon *)getCouponByName:(NSString *)couponName;
-(Coupon *)getCouponByID:(NSInteger)couponID;

@end
