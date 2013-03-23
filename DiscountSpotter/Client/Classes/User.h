
#import <MapKit/MapKit.h>


@interface User : NSObject <MKAnnotation> {
	
	NSString *name;
	NSString *shortDescription;
	
	double latitude;
	double longitude;
	double radius;
}
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *shortDescription;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic, assign) double radius;

@end
