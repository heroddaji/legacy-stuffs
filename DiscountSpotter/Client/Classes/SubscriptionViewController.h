//
//  SubscriptionViewController.h
//  trunk4
//
//  Created by ISAAC on 16-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AugmentedRealityISAACAppDelegate;

@interface SubscriptionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate> {
	AugmentedRealityISAACAppDelegate *appdel;
	
	IBOutlet UITableViewCell *shopCell;
	IBOutlet UITableViewCell *categoryCell;
	IBOutlet UITableViewCell *emailCell;
	
	IBOutlet UITextField *emailTextField;
	
	NSString *shopID;
	NSString *shopCategory;
	UITableView *theTableView;
	
	NSMutableArray *shopArray;
}
@property(nonatomic,retain) AugmentedRealityISAACAppDelegate *appdel;
@property(nonatomic,retain) NSString *shopID;
@property(nonatomic,retain) NSString *shopCategory;
@property(nonatomic,retain) NSMutableArray *shopArray;

@property(nonatomic,retain) IBOutlet UITableViewCell *shopCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *categoryCell;
@property(nonatomic,retain) IBOutlet UITableViewCell *emailCell;
@property(nonatomic,retain) IBOutlet UITextField *emailTextField;
@property(nonatomic,retain) IBOutlet UITableView *theTableView;

-(void)loadShopAndSubscrionCategory;
-(void)cleanShopAndSubscrionCategory;
@end
