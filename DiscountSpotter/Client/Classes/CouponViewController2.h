//
//  CouponViewController2.h
//  trunk4
//
//  Created by ISAAC on 24-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Coupon.h"

@class AugmentedRealityISAACAppDelegate;

@interface CouponViewController2 : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate,CouponDelegate> {
	
	Coupon *thisCoupon;
	AugmentedRealityISAACAppDelegate *appdel;
	UITableViewCell *Cell0;
	UITableViewCell *Cell1;
	UITableViewCell *Cell2;
	UITableViewCell *Cell3;
	UITableViewCell *Cell4;
	
	UITextField *alertTextField;
		
	UIImage *cacheImage;
}

@property(nonatomic,retain) Coupon *thisCoupon;
@property(nonatomic,retain) IBOutlet UITableViewCell *Cell0;
@property(nonatomic,retain) IBOutlet UITableViewCell *Cell1;
@property(nonatomic,retain) IBOutlet UITableViewCell *Cell2;
@property(nonatomic,retain) IBOutlet UITableViewCell *Cell3;
@property(nonatomic,retain) IBOutlet UITableViewCell *Cell4;
@property(nonatomic,retain) UITextField *alertTextField;


-(void)sendSubscriptionToServer;

@end
