

#import "User.h"


@implementation User
@synthesize name,latitude,longitude,shortDescription,radius;


#pragma mark MKAnnotation delegate
- (CLLocationCoordinate2D)coordinate{
	CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = latitude;
	theCoordinate.longitude = longitude;
	return theCoordinate;
}

-(NSString *)title{
	return name;
}

-(NSString *)subtitle{
	return shortDescription;
}

-(void)dealloc{
	[name release];
	[shortDescription release];
	[super dealloc];
}

@end
