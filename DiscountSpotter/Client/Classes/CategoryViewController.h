//
//  CategoryViewController.h
//  trunk4
//
//  Created by ISAAC on 14-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;
@class AugmentedRealityISAACAppDelegate;

@interface CategoryViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource> {

	AugmentedRealityISAACAppDelegate *appdel;
	Location *thisLocation;
	NSMutableArray *productCategories;
	NSString *aCategory;
	
	UITableViewCell *Cell1;
}

@property(nonatomic,retain) Location *thisLocation;
@property(nonatomic,retain) NSMutableArray *productCategories;
@property(nonatomic,retain) NSString *aCategory;

@property(nonatomic,retain) IBOutlet UITableViewCell *Cell1;

-(BOOL)checkIfCategoryIsExist:(NSString *)category inThisArray:(NSArray *)arrayOfCategory;

@end
