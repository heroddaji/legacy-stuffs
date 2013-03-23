//
//  MapViewSettingController.m
//  trunk4
//
//  Created by ISAAC on 29-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewSettingController.h"
#import "MapViewController.h"

@implementation MapViewSettingController
@synthesize Cell1;
@synthesize Cell2;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	UISwitch *cellSwitch = (UISwitch *)[Cell1 viewWithTag:1];
	 cellSwitch.on = [MapViewController sharedManager].isSimulationOn;
	
	UISegmentedControl *cellSegment = (UISegmentedControl *)[Cell2 viewWithTag:1];
	if ([[MapViewController sharedManager] theMap].mapType == MKMapTypeStandard) {
		cellSegment.selectedSegmentIndex = 0;
	}
	if ([[MapViewController sharedManager] theMap].mapType == MKMapTypeSatellite) {
		cellSegment.selectedSegmentIndex = 1;
	}
	if ([[MapViewController sharedManager] theMap].mapType == MKMapTypeHybrid) {
		cellSegment.selectedSegmentIndex = 2;
	}
}


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

-(IBAction)back{
	[self dismissModalViewControllerAnimated:YES];	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
		case 0:{
			
			
			UISegmentedControl *cellSegment = (UISegmentedControl *)[Cell2 viewWithTag:1];
			[cellSegment addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventValueChanged];
			
			return Cell2;
		}
			break;
		
		default:
			break;
	}
	
	return Cell2;
}



-(void)changeMapType:(id)sender{
	UISegmentedControl *cellSegment = (UISegmentedControl *)sender;
	
	//index 0: map
	//index 1: satellite
	//index 2: hybride
	if (cellSegment.selectedSegmentIndex == 0) {
		[[MapViewController sharedManager] theMap].mapType = MKMapTypeStandard;
	}
	
	if (cellSegment.selectedSegmentIndex == 1) {
		[[MapViewController sharedManager] theMap].mapType = MKMapTypeSatellite;
	}
	
	if (cellSegment.selectedSegmentIndex == 2) {
		[[MapViewController sharedManager] theMap].mapType = MKMapTypeHybrid;
	}
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
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
	
	[Cell2 release];
	
    [super dealloc];
}


@end

