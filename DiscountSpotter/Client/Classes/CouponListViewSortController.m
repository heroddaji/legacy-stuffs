//
//  CouponListViewSortController.m
//  trunk4
//
//  Created by ISAAC on 25-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouponListViewSortController.h"
#import "Location.h"
#import "AugmentedRealityISAACAppDelegate.h"

@implementation CouponListViewSortController
@synthesize delegate;
@synthesize theLoc;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"view did load");
	
	appdel = (AugmentedRealityISAACAppDelegate *)[[[UIApplication sharedApplication] delegate] retain];
	shopArray = [[NSMutableArray alloc]init];
	theLoc = [[Location alloc] init];
	
	
	for (Location *loc in appdel.locationArray) {
		if ([loc.type isEqualToString:@"shop"]) {
			[shopArray addObject:loc];
		}
	}
	
	
	//assigne the first one because when pop up, the picker not user the first row yet
	theLoc = (Location *)[shopArray objectAtIndex:0];
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [shopArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	
	Location *loc = [shopArray objectAtIndex:row];
	return loc.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	theLoc = (Location *)[shopArray objectAtIndex:row];
	//NSLog(@"%@", [pickerView description]);
}

-(IBAction)back{
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)sort{
	//NSString *locID = theLoc.ID;
	[self.delegate sortCouponByShopFromViewController:self withLocation:theLoc];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[shopArray release];
	//[theLoc release];
    [super dealloc];
}


@end
