//
//  CouponListViewController.h
//  trunk4
//
//  Created by ISAAC on 04-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponListViewSortController.h"
#import "Coupon.h"

@class User;
@class AugmentedRealityISAACAppDelegate;


@interface CouponListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,sortCouponDelegate,CouponDelegate> {

	IBOutlet UISegmentedControl *segment;
	UITableView *theTableView;
	AugmentedRealityISAACAppDelegate *appdel;
	
	UITableViewCell *sCell;
	NSMutableArray *shopArray;
	NSMutableDictionary *imageCache;
	UIImage *blankImage;
	NSMutableData *downloadData;
	NSIndexPath *theIndexPath;
	
	
}

@property (nonatomic,retain) IBOutlet UITableViewCell *sCell;
@property (nonatomic,retain) IBOutlet UISegmentedControl *segment;
@property (nonatomic,retain) IBOutlet UITableView *theTableView;
@property (nonatomic,retain) NSMutableArray *shopArray;

@property (nonatomic,retain) NSMutableDictionary *imageCache;
@property (nonatomic,retain) UIImage *blankImage;
@property (nonatomic,retain) NSMutableData *downloadData;
@property (nonatomic,retain) NSIndexPath *theIndexPath;
-(IBAction)sortCoupon;
-(IBAction)segmentChangedValue;
-(void)loadAllCoupons;
-(void)loadNewCoupons;
-(void)startDownloadImageFromCoupon:(Coupon *)theCoupon withIndexPath:(NSIndexPath *)indexPath;

//delegate method
-(void)couponImageFinishDownloadFrom:(Coupon *)theCoupon withIndexPath:(NSIndexPath *)indexPath;
@end
