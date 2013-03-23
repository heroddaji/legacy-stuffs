//
//  City.m
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 22-04-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Location.h"


@implementation Location
@synthesize name;
@synthesize latitude;
@synthesize longitude;
@synthesize shortDescription;
@synthesize ID;
@synthesize coupons;
@synthesize type;
@synthesize addressHint;
@synthesize phone;
@synthesize url;
@synthesize email;
@synthesize subscriptionCategories;
@synthesize notificationCoupons;

-(id)init{
	[super init];
	coupons = [[NSMutableArray alloc]init];
	subscriptionCategories = [[NSMutableArray alloc] init];
	notificationCoupons = [[NSMutableArray alloc] init];
	return self;
}

-(id)initWithLocation:(Location *)loc{
	[super init];
	[loc retain];
	
	if (!self) {
		[self release];
	}
	
	self = loc;
	
	[loc release];
	return self;	
}

-(Coupon *)getCouponByName:(NSString *)couponName{
	
	if ([coupons count]>0) {
		for (Coupon *cou in coupons) {
			if ([cou.productName isEqualToString:couponName]) {
				return cou;
			}
		}
	}
	
	return nil;
}

-(Coupon *)getCouponByID:(NSInteger)couponID{

	if ([coupons count]>0) {
		for (Coupon *cou in coupons) {
			if (cou.couponID == couponID) {
				return cou;
			}
		}
	}
	
	return nil;
}

#pragma mark MKAnnotation delegate
- (CLLocationCoordinate2D)coordinate{
	CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = latitude;
	theCoordinate.longitude = longitude;
	return theCoordinate;
}

-(NSString *)title{
	return name;
}

-(NSString *)subtitle{

	NSString *sub = shortDescription;
	
	if ([type isEqualToString:@"shop"]) {
		sub = [sub stringByAppendingFormat:@"\n  Coupons:%d",[self.coupons count]];
	}
	
	return sub;
}

-(void)dealloc{
	[name release];
	[shortDescription release];
	[type release];
	[addressHint release];
	[phone release];
	[url release];
	[email release];
	[coupons release];
	[subscriptionCategories release];
	[notificationCoupons release];
	[super dealloc];
}
@end
