//
//  MapViewController.m
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 22-04-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "JSON.h"
#import "Coupon.h"
#import "LocationViewController.h"
#import "AugmentedRealityISAACAppDelegate.h"
#import "ARMenuButtonExit.h"
#import "User.h"
#import "Location.h"
#import "MapViewSettingController.h"

#if !TARGET_IPHONE_SIMULATOR
#import "WikitudeARViewController.h"
#endif

#define MOVEONE 0.01
#define MAPTYPE_MAP 0
#define MAPTYPE_HYBRIDE 1
#define MAPTYPE_SATELLITE 2


static MapViewController *sharedMapViewController = nil;

@implementation MapViewController
@synthesize theMap;
@synthesize allLocations;
@synthesize navCon;
@synthesize segment;
@synthesize isSimulationOn;



#pragma mark singleton class
+ (MapViewController *)sharedManager
{
    if (sharedMapViewController == nil) {
        sharedMapViewController = [[super allocWithZone:NULL] init];
    }
    return sharedMapViewController;
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



#pragma mark MapViewController cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	NSLog(@"mapviewdidload");
	
	//self.navigationController.navigationBar.hidden = YES;
	
	appdel = [(AugmentedRealityISAACAppDelegate *)[[UIApplication sharedApplication] delegate] retain];
		
#if !TARGET_IPHONE_SIMULATOR
	theMap.showsUserLocation = YES;
#endif
		
	allLocations = [[NSMutableArray alloc]init];

	//Load locations
	for (Location *loc in appdel.locationArray) {
		[allLocations addObject:loc];
	}
	
}


-(void)viewWillAppear:(BOOL)animated{

	segment.selectedSegmentIndex = 0;
	[self segmentChangedValue];
}

-(IBAction)segmentChangedValue{
	
	[theMap removeAnnotations:allLocations];
	
#if TARGET_IPHONE_SIMULATOR
	[theMap removeAnnotation:appdel.user];
#endif
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
	}
		
	[theMap addAnnotations:allLocations];
	
#if TARGET_IPHONE_SIMULATOR
	[theMap addAnnotation:appdel.user];
#endif
		
	static int i = 0;
	if (i==0) {
		[self zoom:appdel.user.coordinate latitudeMeters:appdel.user.radius longitudeMeters:appdel.user.radius goIn:YES ];
		i++;
	}
	
}

-(IBAction)turnSettingOn{
	MapViewSettingController *detailView = [[MapViewSettingController alloc] initWithNibName:@"MapViewSettingController" bundle:nil];
	[self presentModalViewController:detailView animated:YES];
	[detailView release];
}

-(IBAction)backToCurrentLocation{
	[self zoom:appdel.user.coordinate latitudeMeters:appdel.user.radius longitudeMeters:appdel.user.radius goIn:YES ];
}



- (void)zoom:(CLLocationCoordinate2D)zoomCoordinate latitudeMeters:(double)latMeters longitudeMeters:(double)longMeters goIn:(BOOL)inOrOut{
	
	
	if (inOrOut == YES) {
		
		MKCoordinateRegion regionIn;
		
		if (latMeters >= 10000) {
			regionIn = MKCoordinateRegionMakeWithDistance(zoomCoordinate, 2000, 2000);
		}
		else{
			regionIn = MKCoordinateRegionMakeWithDistance(zoomCoordinate, latMeters,longMeters);
		}
		 
		[theMap setRegion:regionIn animated:YES];			
		NSLog(@"lat del:%1.7f, and long del:%1.7f", theMap.region.span.latitudeDelta,theMap.region.span.longitudeDelta);
	}
	else {
		MKCoordinateRegion regionOut = MKCoordinateRegionMakeWithDistance(zoomCoordinate, latMeters*100, longMeters*100);
		[theMap setRegion:regionOut animated:YES];
	}
}

-(IBAction)turnCameraOn{
	[appdel turnCameraOn:self];
}

#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
		NSLog(@"mapView viewForAnnotation");
	
	//NSLog(@"size of location array is %d",[locationArray count]);
	
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
			return nil;
	}
	
	if ([annotation isKindOfClass:[Location class]]) {
		static NSString *locationAnnotation = @"locationAnnotation";
            MKAnnotationView *customPinView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
																			reuseIdentifier:locationAnnotation] autorelease];
			Location *loc = (Location *)annotation;
		
            customPinView.canShowCallout = YES;
			UIImage *flagImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",loc.type]];
            customPinView.image = flagImage;
            customPinView.opaque = NO;
		
			//add small button to push to location view detail
			UIButton* rightButtonA = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButtonA addTarget:self
                            action:nil
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButtonA;
            
            return customPinView;
	}
	
#if TARGET_IPHONE_SIMULATOR
	if ([annotation isKindOfClass:[User class]]) {
		static NSString *userAnnotation = @"userAnnotation";
		MKPinAnnotationView *pinView = (MKPinAnnotationView *)[theMap dequeueReusableAnnotationViewWithIdentifier:userAnnotation];
		
		if (!pinView) {
			MKPinAnnotationView *customPinView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:userAnnotation]autorelease];
			customPinView.pinColor = MKPinAnnotationColorPurple;
			customPinView.animatesDrop = YES;
			customPinView.canShowCallout = YES;
			
			return customPinView;
			
		}
		else {
			pinView.annotation = annotation;
		}
		
		return pinView;
	}
#endif
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
		NSLog(@"mapView annotationView calloutAccessoryControlTapped");
	
//	MKPinAnnotationView *pin = 	(MKPinAnnotationView *)[view.annotation;
	Location *loc = (Location *)view.annotation;
	
	LocationViewController *detailView = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
	detailView.thisLocation = loc;
	[self.navigationController pushViewController:detailView animated:YES];
	
	[detailView release];
	[loc release];
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
	
	static int i = 0;
	if (i == 0) {
		maxDelta = mapView.region.span.longitudeDelta;
		i++;
	}
	
	
	//handle load new location when user zoom in or out in the map
	NSLog(@"lat del:%1.7f, and long del:%1.7f", mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
	double longitudeDetal = mapView.region.span.longitudeDelta;
	
	//check for every 0.15 longitude delta zoom, then update the locations again
	if ( (longitudeDetal - maxDelta) >= 0.3) {
		maxDelta = mapView.region.span.longitudeDelta;
		
		appdel.user.radius = maxDelta * 69370;
		NSLog(@"user radius is:%1.2f",appdel.user.radius);
		//send request if this new zoom has new locations, if it does, load the new location, esle do nothing
		
		[appdel ICS_startLoadingEffectWithMessage:@"na"];
		[appdel ICS_sendMethodLoadLocationsAroundUser:appdel.user];
		[appdel ICS_stopLoadingEffect];
		
		[self segmentChangedValue];
		
		//[NSThread detachNewThreadSelector:@selector(askNewLocation) toTarget:self withObject:nil];
	}
}

-(void)askNewLocation{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	@synchronized(self){
		
		[appdel ICS_sendMethodLoadLocationsAroundUser:appdel.user];
		NSLog(@"ask new loc");
		[self performSelectorOnMainThread:@selector(checkFinishLoading) withObject:nil waitUntilDone:NO];
	}
	
	[pool drain];
}

-(void)checkFinishLoading{
	
	//[appdel ICS_startLoadingEffectWithMessage:@"na"];
	
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCheckServerLoadingStatus:) userInfo:nil repeats:YES];
}

-(void)timerCheckServerLoadingStatus:(NSTimer *)theTimer{
	
	NSLog(@"timerCheckLoadNewRequest...");
	if ([appdel.locationArray count]>0) {
		NSLog(@"loading done");
		[theTimer invalidate];
		
	//	[appdel ICS_stopLoadingEffect];
		
		[self segmentChangedValue];
	}
	
}

- (void)dealloc {
	NSLog(@"dealloc");
	
	theMap.delegate = nil;
	theMap = nil;
	
	[allLocations release];
	[theMap release];
	[super dealloc];
}

@end

