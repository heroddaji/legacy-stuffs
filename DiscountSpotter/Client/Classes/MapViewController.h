//
//  MapViewController.h
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 22-04-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Location;
@class AugmentedRealityISAACAppDelegate;

	
@interface MapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate> {
	
	//loca ivars
	NSMutableArray *allLocations;
	CLLocationManager *locationManager;
	NSString *locationName; //use for passing name into locationViewController
	MKMapView *theMap;
	
	//outlet
	IBOutlet UISegmentedControl *segment;
	
	UINavigationController *navCon;
	
	AugmentedRealityISAACAppDelegate *appdel ;
	
	BOOL isSimulationOn;
	
	double maxDelta;
}

//ivars
@property (nonatomic,assign) BOOL isSimulationOn;

@property (nonatomic,retain) NSMutableArray *allLocations;
@property (nonatomic, retain) UINavigationController *navCon;

//outlet
@property (nonatomic,retain) IBOutlet MKMapView *theMap;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;

//action with UI
-(IBAction)backToCurrentLocation;
-(IBAction)segmentChangedValue;
-(IBAction)turnCameraOn;
-(IBAction)turnSettingOn;

//local functions
-(void)zoom:(CLLocationCoordinate2D)zoomCoordinate latitudeMeters:(double)latMeters longitudeMeters:(double)longMeters goIn:(BOOL)inOrOut;

//singleton
+ (MapViewController *)sharedManager;
+ (id)allocWithZone:(NSZone *)zone;


@end


