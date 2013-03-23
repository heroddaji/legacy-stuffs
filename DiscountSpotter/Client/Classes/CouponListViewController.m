//
//  CouponListViewController.m
//  trunk4
//
//  Created by ISAAC on 04-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponListViewController.h"
#import "AugmentedRealityISAACAppDelegate.h"
#import "Location.h"
#import "User.h"
#import "JSON.h"
#import "CouponViewController2.h"
#import "CouponListViewSortController.h"
#import "Notification.h"

#define NUMOFROW 4

@implementation CouponListViewController
@synthesize theTableView;
@synthesize segment;
@synthesize sCell;

@synthesize shopArray;
@synthesize imageCache;
@synthesize blankImage;
@synthesize downloadData;
@synthesize theIndexPath;


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	///self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.423023 green:0.691077 blue:1 alpha:1];
		
	segment.momentary = YES;
	appdel = [(AugmentedRealityISAACAppDelegate *)[[UIApplication sharedApplication] delegate] retain];
	blankImage = [UIImage imageNamed:@"blank-icon.png"];
	imageCache = [[NSMutableDictionary alloc] init];
	downloadData = [[NSMutableData alloc] init];
	
	
	shopArray = [[NSMutableArray alloc] init];
	
	//[self loadAllCoupons];
	
	
	if ([appdel.notificationCouponArray count] > 0) {
		segment.selectedSegmentIndex = 1; //new segment
		[self loadNewCoupons];
	}
	else {
		segment.selectedSegmentIndex = 0; //all segment
		[self loadAllCoupons];
	}		
}

-(void)viewWillAppear:(BOOL)animated{
	[theTableView reloadData];
}

-(void)loadAllCoupons{
	if ([shopArray count] > 0) {
		[shopArray removeAllObjects];
	}
	
	for (Location *loc in appdel.locationArray) {
		if ([loc.coupons count] > 0 ) {
			[shopArray addObject:loc];
		}
	}

}
-(void)loadNewCoupons{
	
	if ([shopArray count] > 0) {
		[shopArray removeAllObjects];
	}
	
	for (Location *loc in appdel.locationArray) {
		if ([loc.coupons count] > 0 ) {
			Location *newLoc = [[[Location alloc] init] autorelease];
			newLoc.name = loc.name;
			newLoc.latitude = loc.latitude;
			newLoc.longitude = loc.longitude;
			
			if ([loc.coupons count] > 0) {
			
				for (Coupon *newCou in loc.coupons) {
					if ([newCou.status isEqualToString:@"new"]) {
						[newLoc.coupons addObject:newCou];
						[shopArray addObject:newLoc];
					}
				}
			}
		}
	}
}


-(IBAction)segmentChangedValue{
	if(segment.selectedSegmentIndex == 1){
		[self loadNewCoupons];
	}
	else if(segment.selectedSegmentIndex == 0){
		[self loadAllCoupons];
	}
	
	[theTableView reloadData];
}


//the action and its delegate back
-(IBAction)sortCoupon{
	CouponListViewSortController *detailView = [[CouponListViewSortController alloc] initWithNibName:@"CouponListViewSortController" bundle:nil];
	detailView.delegate = self;
	[self presentModalViewController:detailView animated:YES];
	[detailView release];
}

//delegate method from sortView
-(void)sortCouponByShopFromViewController:(UIViewController *)viewController withLocation:(Location *)theLoc{
	[self dismissModalViewControllerAnimated:YES];
	
	[shopArray removeAllObjects];
	[shopArray addObject:theLoc];
	[theTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	if ([shopArray count] > 0) {
		return [shopArray count];
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

	UIView *containerView =	[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)] autorelease];
	
	if ([shopArray count] > 0) {
		
		containerView.backgroundColor = [UIColor redColor];
			//	UIImageView *redBackground= [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"redbar.png"]] autorelease];
			//	[containerView addSubview:redBackground];
		
		Location *loc;
		loc = [shopArray objectAtIndex:section];
		
		UILabel *headerLabel =	[[[UILabel alloc]	  initWithFrame:CGRectMake(10, 0, 300, 25)]	 autorelease];
		headerLabel.text = [NSString stringWithFormat:@"%@ : %1.2f Km",loc.name,[appdel ICS_getDistanceToUserLocationFromLatitude:loc.latitude andLongitude:loc.longitude]/1000];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor blackColor];
		headerLabel.shadowOffset = CGSizeMake(0, 1);
		headerLabel.font = [UIFont boldSystemFontOfSize:22];
		headerLabel.backgroundColor = [UIColor clearColor];
		[containerView addSubview:headerLabel];
		
	}
	
	return containerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 25;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if([shopArray count] > 0){
		Location *loc;
		loc = [shopArray objectAtIndex:section];
		return [loc.coupons count];
		
	}
	
	return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"sCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"CouponCell2" owner:self options:nil];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell = sCell;
    }
	
	static NSString *CellIdentifier2 = @"Cell";
    
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if (cell2 == nil) {
        cell2 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
		[cell2 clearsContextBeforeDrawing];
    }
	
	if ([shopArray count] > 0) {
			
			
			Location *loc = [shopArray objectAtIndex:indexPath.section];;
			Coupon *cou =  [loc.coupons objectAtIndex:indexPath.row];
			cou.delegate =self;
			
			UILabel *couponName = (UILabel *)[cell viewWithTag:1];
			UILabel *couponDesc = (UILabel *)[cell viewWithTag:8];
			UILabel *couponOriginPrice = (UILabel *)[cell viewWithTag:3];
			UILabel *couponDiscountPrice = (UILabel *)[cell viewWithTag:4];
			UILabel *couponRemainDays = (UILabel *)[cell viewWithTag:5];
			
			couponName.text = cou.productName;
			
			//setup the discount desc
			NSString *euroSign = [NSString stringWithUTF8String:"\u20ac"];
			
			if ([cou.discountType isEqualToString:@"percentage"]) {		
				couponDesc.text = [NSString stringWithFormat:@"%1.0f%%",cou.discountValue * 100];
			}	
			if ([cou.discountType isEqualToString:@"absolute off"]) {		
				couponDesc.text = [NSString stringWithFormat:@"-%@%1.0f",euroSign,cou.discountValue];
			}
			
			if ([cou.discountType isEqualToString:@"absolute value"]) {
				couponDesc.text = [NSString stringWithFormat:@"%@%1.0f",euroSign,cou.discountValue];
			}
			
			couponOriginPrice.text = [NSString stringWithUTF8String:"\u20ac"];
			couponOriginPrice.text = [couponOriginPrice.text stringByAppendingFormat:@"%1.0f",cou.productPrice];
			
			couponDiscountPrice.text = [NSString stringWithUTF8String:"\u20ac"];
			couponDiscountPrice.text = [couponDiscountPrice.text stringByAppendingFormat:@"%1.0f",[cou getDiscountPrice]];	
			
			couponRemainDays.text = [NSString stringWithFormat:@"%d days remaining",cou.remainDays];

			if (cou.remainDays == 1) {
				couponRemainDays.text = [NSString stringWithFormat:@"%d day remaining",cou.remainDays];
			}
			if (cou.remainDays == 0) {
					couponRemainDays.text = @"Last day";
			}
			
			UIImageView *couponNewBadgeImage  = (UIImageView *)[cell viewWithTag:7];
			if ([cou.status isEqualToString:@"new"]) {
				couponNewBadgeImage.hidden = NO;
			}
			else {
				couponNewBadgeImage.hidden = YES;
			}
			
			
			//now check for image
			UIImageView *couponImage = (UIImageView *)[cell viewWithTag:6];
			if ([cou.productImage isEqualToString:@""]) {
				//if coupon has no real image, use category icon
				couponImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",cou.productCategory]];
			}
			else {
			
				if (cou.downloadImage != nil) {
					couponImage.image = cou.downloadImage;
				}
				else {
					
					//[imageCache setObject:cell forKey:indexPath];
					
					[self startDownloadImageFromCoupon:cou withIndexPath:indexPath];
					couponImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",cou.productCategory]];
				}
			}

	}
	else {
		cell = cell2;
	}

	
	return cell;
}

-(void)startDownloadImageFromCoupon:(Coupon *)theCoupon withIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"startDownloadImageFromCoupon");

	theCoupon.theIndexPath = indexPath;
	[theCoupon getImageFromProductImageLink];
}

//finish download, delegate back
-(void)couponImageFinishDownloadFrom:(Coupon *)theCoupon withIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"couponImageFinishDownloadFrom");
	
	[theTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([shopArray count] > 0) {
		
		CouponViewController2 *detailView = [[CouponViewController2 alloc] initWithNibName:@"CouponViewController2" bundle:nil];
		Location *loc = [shopArray objectAtIndex:indexPath.section];
		Coupon *cou = [loc.coupons objectAtIndex:indexPath.row];
		
		detailView.thisCoupon = cou;
		 [self.navigationController pushViewController:detailView animated:YES];
		 [detailView release];
	}
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSLog(@"receive  memory warning");
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[imageCache release];
	
	[shopArray release];

	[segment release];
	[theTableView release];
	[appdel release];
	[sCell release];
	
    [super dealloc];
}


@end

