//
//  LocationViewController.m
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 18-05-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "Location.h"
#import "CouponViewController2.h"
#import "User.h"
#import "AugmentedRealityISAACAppDelegate.h"
#import "MapViewController.h"
#import "CategoryViewController.h"

@implementation LocationViewController

@synthesize thisLocation;
@synthesize theTableView;
@synthesize Cell1;
@synthesize Cell2;
@synthesize isCameraOn;
@synthesize infoSection;
@synthesize couponsSection;
@synthesize contactSection;
@synthesize addressSection;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	appdel = (AugmentedRealityISAACAppDelegate *)[[[UIApplication sharedApplication] delegate]retain];
	
	//contact section
	contactSection = [[NSMutableArray alloc] init];
	if (![thisLocation.phone isEqualToString:@""]) {
		[contactSection addObject:[NSString stringWithFormat:@"phone:%@", thisLocation.phone]];
	}
	
	if (![thisLocation.email isEqualToString:@""]) {
		[contactSection addObject:[NSString stringWithFormat:@"email:%@", thisLocation.email]];
	}
	
	if (![thisLocation.url isEqualToString:@""]) {
		[contactSection addObject:[NSString stringWithFormat:@"homepage:%@", thisLocation.url]];
	}
	
	[contactSection addObject:[NSString stringWithString:@"address: loading..."]];
	
	
	//general section used for provide header title, etc..
	headerSections = [[NSMutableArray alloc] init];
	//[headerSections addObject:[[NSString stringWithFormat:@"%@",thisLocation.type]uppercaseString]];
	[headerSections addObject:@""];
	
	if ([thisLocation.coupons count]>0) {
		[headerSections addObject:[NSString stringWithFormat:@"Coupons available:%d",[thisLocation.coupons count]]];
	}
	
	if ([contactSection count]>0) {
		[headerSections addObject:@"Contact"];
	}
	
	
	
	/*the MKReverseGeocoder var will use the latitude and longitude of thisLocation 
	 *to find the real address, which is street, postal code, city , etc...
	 */
	MKReverseGeocoder *geo = [[MKReverseGeocoder alloc]initWithCoordinate:thisLocation.coordinate];
	geo.delegate  = self;
	[geo start];
	
	
}

#pragma mark MKReverseGeocoder
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{

	NSString *address = [NSString stringWithFormat:@"address: %@ \n %@ \n %@ \n %@",placemark.thoroughfare,placemark.postalCode,placemark.locality,placemark.administrativeArea];
	//NSLog(@"%@",address);
	int count = 0;
	for (NSString *s in contactSection) {
		if ([s isEqualToString:@"address: loading..."]) {
			[contactSection replaceObjectAtIndex:count withObject:address];
			break;
		}
		count++;
	}
		
	[self.theTableView reloadData];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	NSLog(@"geocoder didfail");
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [headerSections count]	;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *headerTitle = [headerSections objectAtIndex:section];
	
	if ([headerTitle rangeOfString:@"Coupons available"].length > 0) {
		return [thisLocation.coupons count];
	}
	
	if ([headerTitle isEqualToString:@"Contact"]) {
		return [contactSection count];
	}
	
	if (section == 0) {
		if ([thisLocation.type isEqualToString:@"shop"]) {
			return 3;
		}
		else {
			return 2;
		}

	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	NSString *headerTitle = [headerSections objectAtIndex:section];
	
	if ([headerTitle isEqualToString:@"Subscription"]) {
		return @"";
	}
	else {
		return [headerSections objectAtIndex:section];
	}

	return @"";
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) {
		if (indexPath.row == 1) {
			return 80;
		}
		if (indexPath.row == 2) {
			return 80;
		}
	}
	
	NSString *headerTitle = [headerSections objectAtIndex:indexPath.section];
	
	if ([headerTitle isEqualToString:@"Contact"]) {
		NSString *cellValue = [contactSection objectAtIndex:indexPath.row];
		
		if ([cellValue rangeOfString:@"address:"].length > 0) {
			return 100;
		}
	}
	
	if ([headerTitle rangeOfString:@"Coupons available"].length > 0) {
		return 80;
	}
	
	return 44;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellSubtitle";
    UITableViewCell *cellDefault = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cellDefault == nil) {
        cellDefault = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cellDefault.detailTextLabel.numberOfLines = 5;
		cellDefault.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	else {
		[cellDefault clearsContextBeforeDrawing];
	}

	
	//contact cell
	static NSString *CellIdentifierValue2 = @"CellValue2";
    UITableViewCell *cellValue2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifierValue2];
    if (cellValue2 == nil) {
        cellValue2 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifierValue2] autorelease];
		cellValue2.detailTextLabel.numberOfLines = 5;
    }
	
	//coupon cell
	static NSString *CellIdentifierCoupon = @"CellCoupon";
    UITableViewCell *cellCoupon = [tableView dequeueReusableCellWithIdentifier:CellIdentifierCoupon];
    if (cellCoupon == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:nil];
		cellCoupon =Cell2;
		cellCoupon.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	//location info cell
	static NSString *CellIdentifierLocation = @"CellLocation";
    UITableViewCell *cellLocation = [tableView dequeueReusableCellWithIdentifier:CellIdentifierLocation];
    if (cellLocation == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"LocationViewInfoCell" owner:self options:nil];
		cellLocation =Cell1;
    }
	
	UITableViewCell *cell = cellDefault;
	
	//the shopinfo cell
	if (indexPath.section == 0) {
		
		if (indexPath.row == 0) {
			cell.backgroundColor = [UIColor redColor];
			cell.textLabel.text = thisLocation.name;
			cell.textColor = [UIColor whiteColor];
		}
		
		if (indexPath.row == 1) {
			cell = cellLocation;
			
			//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			UIImageView *cellImageView  = (UIImageView *)[cell viewWithTag:4];
			UILabel *cellTitleLabel = (UILabel *)[cell viewWithTag:1];
			UILabel *cellSubtitleLabel = (UILabel *)[cell viewWithTag:2];
			UILabel *cellDistanceLabel = (UILabel *)[cell viewWithTag:3];
			
			cellImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",thisLocation.type]];
			cellTitleLabel.text = @"Information:";
			cellSubtitleLabel.text = thisLocation.shortDescription;
			cellDistanceLabel.text = [NSString stringWithFormat:@"%1.2f Km",[appdel ICS_getDistanceToUserLocationFromLatitude:thisLocation.latitude andLongitude:thisLocation.longitude]/1000];
		}
		
		//subscription
		if ([thisLocation.type isEqualToString:@"shop"]) {
			if (indexPath.row == 2) {
				cell = cellLocation;
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				UIImageView *cellImageView  = (UIImageView *)[cell viewWithTag:4];
				UILabel *cellTitleLabel = (UILabel *)[cell viewWithTag:1];
				UILabel *cellSubtitleLabel = (UILabel *)[cell viewWithTag:2];
				UILabel *cellDistanceLabel = (UILabel *)[cell viewWithTag:3];
				cellDistanceLabel.hidden =YES;
				
				//cellImageView.image = [UIImage imageNamed:@"subscription-icon.png"];
				cellImageView.hidden = YES;
				cellTitleLabel.text = @"Subscription:";
				cellSubtitleLabel.text = @"Get notification when new coupons available.";
				
			}
		}
		return cell;
	}
	
	//get header section to customise that cell
	NSString *headerTitle = [headerSections objectAtIndex:indexPath.section];
	
	//the coupon cell
	if ([headerTitle rangeOfString:@"Coupons available"].length > 0) {
		cell = cellCoupon;
		Coupon *cou = [thisLocation.coupons objectAtIndex:indexPath.row];
		cou.delegate = self;
		
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
	
	if ([headerTitle isEqualToString:@"Contact"]) {
		
		cell = cellValue2;
		
		NSString *contactValue = [contactSection objectAtIndex:indexPath.row];
	
		if ([contactValue rangeOfString:@"phone:"].length>0) {
			cell.textLabel.text = @"phone:";
			cell.detailTextLabel.text = [contactValue substringFromIndex:[contactValue rangeOfString:@"phone:"].length];
		}
		if ([contactValue rangeOfString:@"email:"].length>0) {
			cell.textLabel.text = @"email:";
			cell.detailTextLabel.text = [contactValue substringFromIndex:[contactValue rangeOfString:@"email:"].length];
		}
		
		if ([contactValue rangeOfString:@"homepage:"].length>0) {
			cell.textLabel.text = @"homepage:";
			cell.detailTextLabel.text = [contactValue substringFromIndex:[contactValue rangeOfString:@"homepage:"].length];
		}
		
		if ([contactValue rangeOfString:@"address:"].length>0) {
			cell.textLabel.text = @"address:";
			cell.detailTextLabel.text = [contactValue substringFromIndex:[contactValue rangeOfString:@"address:"].length];
		}
		
		cell.userInteractionEnabled = YES;
		
	}
	
    return 	cell;
}

//jump to map and select the loc
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
	if (appdel.tabBarController.selectedIndex != 1) {
		appdel.tabBarController.selectedIndex = 1;
		[[MapViewController sharedManager].navigationController popToRootViewControllerAnimated:YES];
		[[MapViewController sharedManager] zoom:thisLocation.coordinate latitudeMeters:100 longitudeMeters:100  goIn:YES];
	}
	else {
		[[MapViewController sharedManager].navigationController popToRootViewControllerAnimated:YES];
		[[MapViewController sharedManager] zoom:thisLocation.coordinate latitudeMeters:100 longitudeMeters:100  goIn:YES];
	}
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
	
//	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	NSString *headerTitle = [headerSections objectAtIndex:indexPath.section];
	
	//if touch a coupon cell 
	if ([headerTitle rangeOfString:@"Coupons available"].length > 0) {
		CouponViewController2 *detailView = [[CouponViewController2 alloc] initWithNibName:@"CouponViewController2" bundle:nil];
		detailView.thisCoupon = [thisLocation.coupons objectAtIndex:indexPath.row];
		
		[self.navigationController pushViewController:detailView animated:YES];
		
		[detailView release];
	}
	
	if (indexPath.section == 0) {
		if ([thisLocation.type isEqualToString:@"shop"]) {
			if (indexPath.row == 2) {
				
				CategoryViewController *categoryView = [[CategoryViewController alloc] initWithStyle:UITableViewStylePlain];
				categoryView.thisLocation = thisLocation;
			
				[self.navigationController pushViewController:categoryView animated:YES];
				[categoryView release];
			}
		}
	}
	
	//if touch a contact cell
	if ([headerTitle isEqualToString:@"Contact"]) {
		
		NSString *contactValue = [contactSection objectAtIndex:indexPath.row];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone" message:@"Do you want to exit and make this call?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
		
		if ([contactValue rangeOfString:@"phone:"].length>0) {
			alert.title = @"Phone";
			alert.message = @"Do you want to exit and make this call?";
			[alert show];
			[alert release];
		}
		
		if ([contactValue rangeOfString:@"email:"].length>0) {
			alert.title = @"Email";
			alert.message = @"Do you want to exit and open Mail?";
			[alert show];
			[alert release];
		}
		
		if ([contactValue rangeOfString:@"homepage:"].length>0) {
			alert.title = @"Website";
			alert.message = @"Do you want to exit and open the link?";
			[alert show];
			[alert release];
		}
		
	}
	
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	NSString *contactString;
	
	if (buttonIndex==0) {
		
		if ([alertView.title isEqualToString:@"Phone"]) {
			
			for (NSString *s in contactSection) {
				if ([s rangeOfString:@"phone:"].length>0) {
					contactString = [s substringFromIndex:[s rangeOfString:@"phone:"].length] ;
					break;
				}
			}
			
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",contactString]]];
			//tel:1-408-555-5555
		}
		
		if ([alertView.title isEqualToString:@"Email"]) {
			
			for (NSString *s in contactSection) {
				if ([s rangeOfString:@"email:"].length>0) {
					contactString = [s substringFromIndex:[s rangeOfString:@"email:"].length] ;
					break;
				}
			}
			
			
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",contactString]]];
			//mailto:frank@wwdcdemo.example.com
		}
		
		if ([alertView.title isEqualToString:@"Website"]) {
			
			for (NSString *s in contactSection) {
				if ([s rangeOfString:@"homepage:"].length>0) {
					contactString = [s substringFromIndex:[s rangeOfString:@"homepage:"].length] ;
					break;
				}
			}
			
			
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",contactString]]];
			//http://
		}
	}
	else if (buttonIndex == 1 ) {
		;
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
 	NSLog(@"unload");
}


- (void)dealloc {
	
	[thisLocation release];
	[appdel release];
	[theTableView release];	
	[Cell1 release];
	[Cell2 release];
	[headerSections release];
	[infoSection release];
	[couponsSection release];
	[contactSection release];
	[addressSection release];
	[super dealloc];
}


@end

