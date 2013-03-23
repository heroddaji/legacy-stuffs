//
//  ListViewController.m
//  trunk4
//
//  Created by dai on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "JSON.h"
#import "Location.h"
#import "LocationViewController.h"
#import "AugmentedRealityISAACAppDelegate.h"
#import "User.h"


static ListViewController *sharedListViewController = nil;


@implementation ListViewController

@synthesize theTableView;
@synthesize segment;
@synthesize allLocations;
@synthesize customCell;

#pragma mark singleton class
+ (ListViewController *)sharedManager
{
    if (sharedListViewController == nil) {
        sharedListViewController = [[super allocWithZone:NULL] init];
    }
    return sharedListViewController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}



 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];	
	 appdel = (AugmentedRealityISAACAppDelegate *)[[[UIApplication sharedApplication] delegate]retain ];
	NSLog(@"%@", [self.navigationController.navigationBar.tintColor description] );
	 allLocations = [[NSMutableArray alloc] init];
	
	 //load locations
	 [allLocations removeAllObjects];
	 for (Location *loc in appdel.locationArray) {
		 [allLocations addObject:loc];
	 }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	segment.selectedSegmentIndex =0;
	[self segmentChangedValue];
}

-(IBAction)segmentChangedValue{
		
	/* Filter the display of different type of location
	 * case 0: "all" index, show all locations
	 * case 1: "shop" index, show shop
	 * case 2: "bank" index, show bank
	 * case 3: "ATM" index, show ATM
	 */
	
	[allLocations removeAllObjects];
	switch (segment.selectedSegmentIndex) {
		case 0:{
			for (Location *loc in appdel.locationArray) {
				[allLocations addObject:loc];
			}
		}
			break;
		case 1:{
			for (Location *loc in appdel.locationArray) {
				if ([loc.type isEqualToString:@"shop"]) {
					[allLocations addObject:loc];
				}
				
			}
		}
			break;
		case 2:{
			for (Location *loc in appdel.locationArray) {
				if ([loc.type isEqualToString:@"bank"]) {
					[allLocations addObject:loc];
				}
			}
		}
			break;
		case 3:{
			for (Location *loc in appdel.locationArray) {
				if ([loc.type isEqualToString:@"atm"]) {
					[allLocations addObject:loc];
				}
			}
		}
			break;
		default:[theTableView reloadData];
			break;
	}
	
	[theTableView reloadData];
}

 //call the function to turn camera on in the delegate API
-(IBAction)turnCameraOn{
	[appdel turnCameraOn:self];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [allLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        /*cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.detailTextLabel.numberOfLines = 10;
		*/
		
		 [[NSBundle mainBundle] loadNibNamed:@"ListViewCell" owner:self options:nil];
		 cell =customCell;
		 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		 
    }
	
	Location *cellLocation = [allLocations objectAtIndex:indexPath.row];
	
	UIImageView *locImage = (UIImageView *)[cell viewWithTag:1];
	UILabel *locName = (UILabel *)[cell viewWithTag:2];
	UILabel *locDesc = (UILabel *)[cell viewWithTag:3];
	
	locName.text = cellLocation.name;
	locDesc.text = [NSString stringWithFormat:@"Distance: %1.2f KM.",[appdel ICS_getDistanceToUserLocationFromLatitude:cellLocation.latitude 
																												  andLongitude:cellLocation.longitude]/1000];
	
	if ([cellLocation.type isEqualToString:@"shop"]) {
		locDesc.text = [locDesc.text stringByAppendingFormat:@" (%d Coupons)",[cellLocation.coupons count]];
	}
	
	locImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",cellLocation.type]];

	return cell;
} 


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//push to the LocationView, also the location at the pushed index
	
	LocationViewController *detailView = [[LocationViewController alloc]initWithNibName:@"LocationViewController" 
																		bundle:nil];	
	
	Location *selectedCellLocation = (Location *)[allLocations objectAtIndex:indexPath.row]; 
	detailView.thisLocation = selectedCellLocation;
	
	[self.navigationController pushViewController:detailView animated:YES];
	[detailView release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	NSLog(@"viewDidUnload");
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {	
	[customCell release];
	[appdel release];
	[theTableView release];
	[segment release];
	[allLocations release];
	[super dealloc];
}


@end
