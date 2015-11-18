
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/*!
 @class WTPoi
 @abstract POI-representation in WIKITUDE API
 
 Created by Hannes Staffler, sengaro GmbH on 21.07.09.
 
 Edited by Florian Scholochow, sengaro GmbH on 27.01.10.
 
 Copyright 2010 Mobilizy GmbH.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 
 you may not use this file except in compliance with the License.
 
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 
 distributed under the License is distributed on an "AS IS" BASIS,
 
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 
 See the License for the specific language governing permissions and
 
 limitations under the License.
 */
@interface WTPoi : NSObject <MKAnnotation> {
	
	// poi information
	NSString *name;
	NSString *shortDescription;
	NSString *thumbnail;
	NSString *phone;
	NSString *url;
	NSString *email;
	NSString *paddress;
	NSString *attachmentURL;
	NSString *attachmentName;
	NSString *ID;
	NSString *icon;
	
	// geographical data
	double latitude;
	double longitude;
	double altitude;
	
	//NEW TO THE INTERFACE
	double distance;
}

/*!
 @abstract usually calculated from the current location, fall back is data received from server
*/
@property (readwrite)			double distance; 

/*!
 @abstract required
*/
@property (nonatomic, retain) NSString *name;

/*!
 @abstract optional
 */
@property (nonatomic, retain) NSString *shortDescription;

/*!
 @abstract optional; a URL to the thumbnail, displayed in the bubble
 */
@property (nonatomic, retain) NSString *thumbnail;

/*!
 @abstract optional
 */
@property (nonatomic, retain) NSString *phone;

/*!
 @abstract optional
 */
@property (nonatomic, retain) NSString *url;

/*!
 @abstract optional
 */
@property (nonatomic, retain) NSString *email;

/*!
 @abstract optional
 */
@property (nonatomic, retain) NSString *paddress;

/*!
 @abstract optional; a URL to an attachment
 */
@property (nonatomic, retain) NSString *attachmentURL;
@property (nonatomic, retain) NSString *attachmentName;


@property (nonatomic, retain) NSString *ID;

/*!
 @abstract optional
 */
@property (nonatomic, retain) NSString *icon;

/*!
 @abstract required
 */
@property (readwrite) double latitude;

/*!
 @abstract required
 */
@property (readwrite) double longitude;

/*!
 @abstract optional; Defaults to -32768 and is treated in the Camera View as if the POI would be the same altitude as the user’s phone.
 */
@property (readwrite) double altitude;


//Calculated Properties
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocation *location;

- (id) initWithName: (NSString*) _name
		AndLatitude: (double) _latitude
	   AndLongitude: (double) _longitude;

@end
