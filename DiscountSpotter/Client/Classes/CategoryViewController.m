//
//  CategoryViewController.m
//  trunk4
//
//  Created by ISAAC on 14-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "AugmentedRealityISAACAppDelegate.h"
#import "Coupon.h"
#import "Location.h"



@implementation CategoryViewController
@synthesize thisLocation;
@synthesize productCategories;
@synthesize aCategory;
@synthesize Cell1;

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

	appdel = (AugmentedRealityISAACAppDelegate *)[[[UIApplication sharedApplication] delegate]retain];
	
    // Uncomment the following line to preserve selection between presentations.
   // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	productCategories = [[NSMutableArray alloc] initWithObjects:@"Mobile",@"Television",@"Camera",@"Camcorder",@"Desktop",@"Laptop",@"Printer",@"Usb",nil];
	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
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
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	
    return [productCategories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
		[[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil];
		cell =Cell1;
		
    }
	else{
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];	
	}
    
	UIImageView *cellImage= (UIImageView *)[cell viewWithTag:1];
	UILabel *cellLabel = (UILabel *)[cell viewWithTag:2];
	
    cellLabel.text = [productCategories objectAtIndex:indexPath.row];
	cellImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[productCategories objectAtIndex:indexPath.row]]];
	
	if ([appdel ICS_checkTheSubscriptionOfShop:thisLocation.ID andProductCategory:[productCategories objectAtIndex:indexPath.row]]== YES) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = [UIColor blueColor];
	}
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if ([appdel ICS_checkTheSubscriptionOfShop:thisLocation.ID andProductCategory:[productCategories objectAtIndex:indexPath.row]]== YES) {
	//if already subscribe, then remove it
		
		[appdel ICS_removeSubscriptionOfShop:thisLocation.ID andProductCategory:[productCategories objectAtIndex:indexPath.row]];
		
		aCategory = [productCategories objectAtIndex:indexPath.row];
		[NSThread detachNewThreadSelector:@selector(sendSubscriptionToServer) toTarget:self withObject:nil];
	}
	
	//if is not subscribe, then go to subscibe
	else {
		
		[appdel ICS_addSubscriptionOfShop:thisLocation.ID andProductCategory:[productCategories objectAtIndex:indexPath.row]];
		
		aCategory = [productCategories objectAtIndex:indexPath.row];
		[NSThread detachNewThreadSelector:@selector(sendSubscriptionToServer) toTarget:self withObject:nil];
	}
	
	[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
	//[tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];

}

-(void)sendSubscriptionToServer{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *yesOrNo;
	if ([appdel ICS_checkTheSubscriptionOfShop:thisLocation.ID andProductCategory:aCategory]== YES){
		yesOrNo = @"YES";
	} 
	else {
		yesOrNo = @"NO";
	}
	
	@synchronized(appdel){
		@synchronized(thisLocation){
			@synchronized(aCategory){
				[appdel ICS_sendMethodRegisterSubscriptionToShop:thisLocation.ID withCategory:aCategory withSubscribeOrUnsubscribe:yesOrNo];	
			}
		}
	}
	
	[pool drain];
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
	
	[Cell1 release];
	[thisLocation release];
	[productCategories release];
	//[aCategory release];
	[appdel release];
	
    [super dealloc];
}


@end

