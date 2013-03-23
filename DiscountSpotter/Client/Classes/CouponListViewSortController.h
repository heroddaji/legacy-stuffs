//
//  CouponListViewSortController.h
//  trunk4
//
//  Created by ISAAC on 25-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol sortCouponDelegate;

@class AugmentedRealityISAACAppDelegate;
@class Location;
@interface CouponListViewSortController : UIViewController<UIPickerViewDelegate> {
	AugmentedRealityISAACAppDelegate *appdel;
	NSMutableArray *shopArray;
	
	id<sortCouponDelegate>delegate;
	Location *theLoc;
}

@property(nonatomic,assign)id<sortCouponDelegate>delegate;
@property(nonatomic,retain)Location *theLoc;

-(IBAction)back;
-(IBAction)sort;

@end

@protocol sortCouponDelegate
-(void)sortCouponByShopFromViewController:(UIViewController *)viewController withLocation:(Location *)theLoc;
@end