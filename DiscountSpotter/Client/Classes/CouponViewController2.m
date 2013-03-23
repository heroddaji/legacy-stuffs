//
//  CouponViewController2.m
//  trunk4
//
//  Created by ISAAC on 24-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponViewController2.h"
#import "AugmentedRealityISAACAppDelegate.h"
#import "URLViewController.h"
#import "Location.h"
#import "LocationViewController.h"
#import "MapViewController.h"
#import "CouponListViewController.h"
#import "ListViewController.h"

@implementation NSDate (FormattedStrings)
- (NSString *)dateStringWithStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:style];
    return [dateFormatter stringFromDate:self];
}
@end

@implementation CouponViewController2
@synthesize thisCoupon;
@synthesize Cell0;
@synthesize Cell1;
@synthesize Cell2;
@synthesize Cell3;
@synthesize Cell4;
@synthesize alertTextField;


///GLOBAL IVAR
BOOL isSubscribed = NO;

#pragma mark -
#pragma mark View lifecycle


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 
		NSLog(@"initWithNibName");
	}
	return self;
}
 

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
  //  self.clearsSelectionOnViewWillAppear = NO;
	
	if ([thisCoupon.status isEqualToString:@"new"]) {
		UIBarButtonItem *signoffCouponButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign" style:UIBarButtonItemStylePlain target:self action:@selector(signoffCoupon:)];
		self.navigationItem.rightBarButtonItem = signoffCouponButton;
	}
	
	appdel = [(AugmentedRealityISAACAppDelegate *)[[UIApplication sharedApplication] delegate] retain];
	
}


-(void)signoffCoupon:(id)sender{
	[appdel ICS_sendSignedOffDateWithCouponID:thisCoupon.couponID];
	thisCoupon.status = @"signed";
	[appdel ICS_sendMethodLoadNotification];
	[self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	thisCoupon.isProductCategorySubscribed = [appdel ICS_checkTheSubscriptionOfShop:thisCoupon.shopID andProductCategory:thisCoupon.productCategory];

	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	return 5;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{	
	return @"Coupon information";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row == 1) {
		return 118;
	}
	if (indexPath.row == 2) {
		return 72;
	}
	
	return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryNone;
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.textLabel.textColor = [UIColor blackColor];
		[cell clearsContextBeforeDrawing];
    }
	else {
		//cell.accessoryType = UITableViewCellAccessoryNone;
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.textLabel.textColor = [UIColor blackColor];
		
		[cell clearsContextBeforeDrawing];
	}

	
	if (indexPath.row == 0) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.font = [UIFont fontWithName:@"Helvetica-Regular" size:17];
		cell.backgroundColor = [UIColor redColor];
		cell.textLabel.text = [NSString stringWithFormat:@"%@ > %@",[appdel ICS_getLocationFromID:thisCoupon.shopID].name,thisCoupon.productName];
		cell.textLabel.numberOfLines = 5;
		cell.textLabel.textColor = [UIColor whiteColor];
		
		
	}

	if (indexPath.row == 1) {
		
		UITextView *couponProductDesc = (UITextView *)[Cell0 viewWithTag:2];
		couponProductDesc.text = thisCoupon.productDescription;
		
		//download image
		UIImageView *couponImage = (UIImageView *)[Cell0 viewWithTag:1];
		if ([thisCoupon.productImage isEqualToString:@""]) {
			//if coupon has no real image, use category icon
			couponImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",thisCoupon.productCategory]];
		}
		else {				

			if (thisCoupon.downloadImage != nil) {
				couponImage.image = thisCoupon.downloadImage;
			}
			else {
				thisCoupon.delegate = self;
				[thisCoupon getImageFromProductImageLink];
				couponImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",thisCoupon.productCategory]];
			}
		}

		return Cell0; 
	}
	
	//discount and date cell
	if (indexPath.row == 2) {
		
		UILabel *couponOriginPrice = (UILabel *)[Cell1 viewWithTag:1];
		UILabel *couponDiscountPrice = (UILabel *)[Cell1 viewWithTag:2];
		UILabel *couponDiscountSave = (UILabel *)[Cell1 viewWithTag:3];
		UILabel *couponFromDate = (UILabel *)[Cell1 viewWithTag:4];
		UILabel *couponToDate = (UILabel *)[Cell1 viewWithTag:5];
		
		NSString *euro = [NSString stringWithUTF8String:"\u20ac"];
		
		couponOriginPrice.text = [NSString stringWithFormat:@"%@%1.0f",euro,thisCoupon.productPrice];
		couponDiscountPrice.text = [NSString stringWithFormat:@"%@%1.0f",euro,[thisCoupon getDiscountPrice]];
		couponDiscountSave.text = [NSString stringWithFormat:@"(save %@%1.0f)",euro,thisCoupon.productPrice - [thisCoupon getDiscountPrice]];
		
		couponFromDate.text = [NSString stringWithFormat:@"%@",[[thisCoupon.fromDate description] substringToIndex:10]];
		couponToDate.text = [NSString stringWithFormat:@"%@",[[thisCoupon.toDate description] substringToIndex:10]];
		
		return Cell1; 
	}

	if (indexPath.row == 3) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:17];
		cell.textLabel.textColor = [UIColor redColor];
		cell.textLabel.text = @"  Get coupon now!";
	}
	
	if (indexPath.row == 4) {
		//[cell clearsContextBeforeDrawing];
		
		if (thisCoupon.isProductCategorySubscribed == YES) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:17];
			cell.textLabel.textColor = [UIColor redColor];
			cell.textLabel.text = [NSString stringWithFormat:@"  Subscribe to %@",thisCoupon.productCategory];
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:17];
			cell.textLabel.textColor = [UIColor redColor];
			cell.textLabel.text = [NSString stringWithFormat:@"  Subscribe to %@",thisCoupon.productCategory];
		}
	}
	
	
	
	return cell;
}

-(void)couponImageFinishDownloadFrom:(Coupon *)theCoupon withIndexPath:(NSIndexPath *)indexPath{
	UIImageView *couponImage = (UIImageView *)[Cell0 viewWithTag:1];
	couponImage.image = theCoupon.downloadImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


			//get barcode
		if (indexPath.row == 3) {
			//check if email is exist
			if (![[appdel.userInformationDict objectForKey:@"email"] isEqualToString:@""]) {
				
				[appdel ICS_startLoadingEffectWithMessage:@"In a moment..."];
				URLViewController *barcodeView = [[URLViewController alloc] initWithNibName:@"URLViewController" bundle:nil];
				barcodeView.URL = thisCoupon.barcode;
				
				[self.navigationController pushViewController:barcodeView animated:YES];
				
				[barcodeView release];
			}
			
			else {
				
				//all these code to pop up the alertview to fill in email
				UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"We need your email" delegate:self
													 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",nil];
				
				alertTextField = [[UITextField alloc]initWithFrame:CGRectMake(12.0, 45.0, 260.0, 30.0)];
				alertTextField.text = @"myEmail@email.nl";
				alertTextField.delegate = self;
				alertTextField.clearButtonMode = UITextFieldViewModeAlways;
				alertTextField.placeholder = @"Please enter your Email";
				[alertTextField setBackgroundColor:[UIColor whiteColor]];
				[alert addSubview:alertTextField];
				
				//CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 70.0);
				//[alert setTransform:myTransform];
				
				//check email before show
				if ([appdel.userInformationDict valueForKey:@"email"]!=nil) {
					alertTextField.text = [appdel.userInformationDict valueForKey:@"email"];
				}
				
				[alert show];
				[alert release];
				
			}
		}
		
			//subscribe button
		if (indexPath.row == 4) {
			//if already subscribe, then go to unsubscribe
			if (thisCoupon.isProductCategorySubscribed == YES) {
				thisCoupon.isProductCategorySubscribed = NO;
				
				[appdel ICS_removeSubscriptionOfShop:thisCoupon.shopID andProductCategory:thisCoupon.productCategory];
				
				[NSThread detachNewThreadSelector:@selector(sendSubscriptionToServer) toTarget:self withObject:nil];
			}
			
			//if is not subscribe, then go to subscibe
			else {
				thisCoupon.isProductCategorySubscribed = YES;
				
				[appdel ICS_addSubscriptionOfShop:thisCoupon.shopID andProductCategory:thisCoupon.productCategory];
				
				[NSThread detachNewThreadSelector:@selector(sendSubscriptionToServer) toTarget:self withObject:nil];
			}
			
			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
		}
	
		
	
	
}

-(void)sendSubscriptionToServer{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *yesOrNo;
	if (thisCoupon.isProductCategorySubscribed == YES){
		 yesOrNo = @"YES";
	} 
	else {
		yesOrNo = @"NO";
	}
	
	@synchronized(appdel){
		@synchronized(thisCoupon){
			[appdel ICS_sendMethodRegisterSubscriptionToShop:thisCoupon.shopID withCategory:thisCoupon.productCategory withSubscribeOrUnsubscribe:yesOrNo];	
		}
	}
	
	[pool drain];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if (buttonIndex == 0) {
		;
	}
	else {
		
		[alertTextField resignFirstResponder];
		
		if ([appdel ICS_validateEmail:alertTextField.text] == YES) 
		{
			//push to the arcode view, ALSO ASSIGN SIGNEDOFFDATE TO THE SERVER
			if ([thisCoupon.status isEqualToString:@"new"]) {
				[appdel ICS_sendSignedOffDateWithCouponID:thisCoupon.couponID];
				thisCoupon.status = @"signed";
				[appdel ICS_sendMethodLoadNotification];
			}
			
			URLViewController *detailView = [[URLViewController alloc]initWithNibName:@"URLViewController" bundle:nil];
			detailView.URL = thisCoupon.barcode;
			[self.navigationController pushViewController:detailView animated:YES];
			[detailView release];
		} 
		//Invalid email address 
		else 
		{ 
			UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid email" delegate:nil
												  cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert2 show];
			[alert2 release];
		} 
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[thisCoupon release];
	[appdel release];
	[Cell0 release];
	[Cell1 release];
	[Cell2 release];
	[Cell3 release];
	[Cell4 release];
	[alertTextField release];
}


@end

