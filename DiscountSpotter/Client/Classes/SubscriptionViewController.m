//
//  MoreViewController.m
//  trunk4
//
//  Created by ISAAC on 04-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "AugmentedRealityISAACAppDelegate.h"
#import "PlistViewController.h"
#import "Subscription.h"
#import "Location.h"

@implementation SubscriptionViewController
@synthesize shopCell;
@synthesize categoryCell;
@synthesize emailCell;
@synthesize emailTextField;
@synthesize shopID;
@synthesize shopCategory;
@synthesize theTableView;
@synthesize shopArray;

#define kIndex 1

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 // Uncomment the following line to preserve selection between presentations.
 self.clearsSelectionOnViewWillAppear = NO;
 
 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 
 }
 */


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.423023 green:0.691077 blue:1 alpha:1];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	appdel = [(AugmentedRealityISAACAppDelegate *)[[UIApplication sharedApplication] delegate] retain];
	 
	shopArray = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
	NSLog(@"viewWillAppear");
	
	emailTextField.text = [appdel.userInformationDict objectForKey:@"email"];
	
	[self loadShopAndSubscrionCategory];
	[theTableView reloadData];
}

-(void)loadShopAndSubscrionCategory{
	
	//the algorethtm is go through each category, find the shop id, add to that shop the subscibe category
	//then after that, go throguht all the shop, check which one has the array count > 0
	
	//clean it first
	[self cleanShopAndSubscrionCategory];
	
	for (Subscription *aSub in appdel.subscriptionArray){
		
		Location *loc =  [appdel ICS_getLocationFromID:aSub.shopID];
		[loc.subscriptionCategories addObject:aSub];
	}
	
	for (Location *loc in appdel.locationArray) {
		if ([loc.subscriptionCategories count]>0) {
			[shopArray addObject:loc];
		}
	}	
}

-(void)cleanShopAndSubscrionCategory{
	[shopArray removeAllObjects];
	
	for (Location *loc in appdel.locationArray) {
		if ([loc.subscriptionCategories count]>0) {
			[loc.subscriptionCategories removeAllObjects];
		}
	}	
}

#pragma mark tableView Delegate and data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	if ([shopArray count] > 0) {
		return [shopArray count];
	}
    
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	if ([shopArray count] > 0) {
		Location *loc = [shopArray objectAtIndex:section];
		
		return [loc.subscriptionCategories count]+kIndex;
	}
	
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
	if ([shopArray count] > 0) {
		Location *loc = [shopArray objectAtIndex:section];
		
		return [NSString stringWithFormat:@"%@ subsriptions",loc.name];
	}
	
	return @"You have no subscription. \nYou can subscribe for shop \ncategory to get notify when \nnew coupons available!";
	
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	
	return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
		
	static NSString *CellIdentifier = @"ShopCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"ShopSubsriptionCell" owner:self options:nil];	
		cell = shopCell;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	
		UIImageView *cellShopImage = (UIImageView *)[cell viewWithTag:4];
		UIImageView *cellCategoryImage = (UIImageView *)[cell viewWithTag:3];
		UILabel *cellShop = (UILabel *)[cell viewWithTag:1];
		UILabel *cellCategory = (UILabel *)[cell viewWithTag:2];
		
		Location *loc = [shopArray objectAtIndex:indexPath.section];
		
		if (indexPath.row == 0) {
			cellShopImage.hidden = NO;
			cellCategoryImage.hidden = YES;
			cellShop.hidden = NO;
			cellCategory.hidden = YES;
			
			cellShop.text = loc.name;
		}
		
		else {
			cellShopImage.hidden = YES;
			cellCategoryImage.hidden = NO;
			cellShop.hidden = YES;
			cellCategory.hidden = NO;
			
			Subscription *sub = [loc.subscriptionCategories objectAtIndex:indexPath.row - kIndex];
			cellShop.text = loc.name;
			cellCategory.text = sub.productCategory;
			cellCategoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",sub.productCategory]];
		}

	
	
	return cell;
}

#pragma mark editing tableView
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
    [theTableView setEditing:editing animated:YES];
  
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   
	//return UITableViewCellEditingStyleInsert;
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	Location *loc = [shopArray objectAtIndex:indexPath.section];
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		if (indexPath.row == 0) {
			
			for (Subscription *sub in loc.subscriptionCategories) {
					
					//delete in subscribeArray
					[appdel ICS_removeSubscriptionOfShop:sub.shopID andProductCategory:sub.productCategory];
					
					//send to server
					[NSThread detachNewThreadSelector:@selector(sendSubscriptionToServer:) toTarget:self withObject:sub];
				}
			
			
			[self loadShopAndSubscrionCategory];
			[theTableView reloadData];
		}
		else {
			
			Subscription *sub = [loc.subscriptionCategories objectAtIndex:indexPath.row - kIndex];
			
			//delete in subscribeArray
			[appdel ICS_removeSubscriptionOfShop:sub.shopID andProductCategory:sub.productCategory];

			//send to server
			[NSThread detachNewThreadSelector:@selector(sendSubscriptionToServer:) toTarget:self withObject:sub];
			
			//delete in each shop
			[loc.subscriptionCategories removeObjectAtIndex:indexPath.row - kIndex];
			
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			
			if ([loc.subscriptionCategories count] == 0) {
				[self loadShopAndSubscrionCategory];
				[theTableView reloadData];
			}
		}
    }
}

-(void)sendSubscriptionToServer:(Subscription *)sub{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	@synchronized(appdel){
		@synchronized(sub){
			[appdel ICS_sendMethodRegisterSubscriptionToShop:sub.shopID withCategory:sub.productCategory withSubscribeOrUnsubscribe:@"NO"];	
		}
	}
	
	[pool drain];
}


#pragma mark textFieldDeltage
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	NSLog(@"user has enter email");
	[textField resignFirstResponder];
	
	//now validate email
	if ([appdel ICS_validateEmail:textField.text] == YES) {
		;
	}
	else {
		
		if ([[appdel.userInformationDict objectForKey:@"email"] isEqualToString:@""]) {
			textField.text = @"";
		}
		else {
			textField.text = [appdel.userInformationDict objectForKey:@"email"];
		}

		
		UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid email" delegate:nil
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert2 show];
		[alert2 release];
	}

	
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[appdel release];
	[shopCell release];
	[categoryCell release];
	[emailCell release];
	[emailTextField release];
	[shopID release];
	[shopArray release];
	[shopCategory release];
	[theTableView release];
    [super dealloc];
}


@end
