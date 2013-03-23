//
//  ListViewController.h
//  trunk4
//
//  Created by dai on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class AugmentedRealityISAACAppDelegate;
@class Location;

@interface ListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	
	UITableView *theTableView;
	IBOutlet UISegmentedControl *segment;
	
	AugmentedRealityISAACAppDelegate *appdel ;
	NSMutableArray *allLocations;
	
	UITableViewCell *customCell;
}

@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain ) IBOutlet UISegmentedControl *segment;
@property (nonatomic, retain ) NSMutableArray *allLocations;
@property (nonatomic, retain ) 	IBOutlet UITableViewCell *customCell;

-(IBAction)segmentChangedValue;
-(IBAction)turnCameraOn;


//singleton
+ (ListViewController *)sharedManager;
+ (id)allocWithZone:(NSZone *)zone;

@end
