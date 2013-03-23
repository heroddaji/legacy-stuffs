//
//  LocationViewController.h
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 18-05-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h> //use for MKReverseGeocoderDelegate
#import "Coupon.h"

@class Location;
@class AugmentedRealityISAACAppDelegate;

@interface LocationViewController : UIViewController <MKReverseGeocoderDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIAlertViewDelegate,CouponDelegate> 
{
	Location *thisLocation;
	AugmentedRealityISAACAppDelegate *appdel;
	UITableView *theTableView;	
	
	UITableViewCell *Cell1;
	UITableViewCell *Cell2;
		
	BOOL isCameraOn;
	
	NSMutableArray *infoSection;
	NSMutableArray *couponsSection;
	NSMutableArray *contactSection;
	NSMutableArray *addressSection;
	
	NSMutableArray *headerSections;
	
	
}

@property (nonatomic,retain) Location *thisLocation;
@property (nonatomic,retain) NSMutableArray *infoSection;
@property (nonatomic,retain) NSMutableArray *couponsSection;
@property (nonatomic,retain) NSMutableArray *contactSection;
@property (nonatomic,retain) NSMutableArray *addressSection;

@property (nonatomic, retain) IBOutlet	UITableView *theTableView;
@property (nonatomic, retain) IBOutlet	UITableViewCell *Cell1;
@property (nonatomic, retain) IBOutlet UITableViewCell *Cell2;
@property (nonatomic, assign) BOOL isCameraOn;

-(void)startDownloadImageFromCoupon:(Coupon *)theCoupon withIndexPath:(NSIndexPath *)indexPath;


@end



