

#import <Foundation/Foundation.h>
#import "WTPoi.h"
#import "WikitudeARViewControllerDelegate.h"
#import "WikitudeARCustomMenuButton.h"

/*!
 @class WikitudeAR
 @abstract Main class of the WIKITUDE API
 
 Created by Florian Scholochow, sengaro GmbH on 27.01.10.
 
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

@interface WikitudeARViewController : NSObject {
	id<WikitudeARViewControllerDelegate> delegate;



}

@property (nonatomic, assign) id<WikitudeARViewControllerDelegate> delegate;


+ (WikitudeARViewController *)sharedInstance;

- (id) initWithDelegate: (id<WikitudeARViewControllerDelegate>) aDelegate
	 applicationPackage: (NSString *) aPackageName 
		 applicationKey: (NSString *) anAppKey 
		applicationName: (NSString *) anAppName 
		  developerName: (NSString *) aDevName;
 /*!
  @abstract initialize WikitudeAR with credentials from http://www.wikitude.org/developers
  
  @param _appPackage Application package (e.g. com.mobilizy.testarapp)
  @param _appKey Application Key (received after registration) - pass nil for testing without registration (beta-overlay)
  @param _appName Application Name (e.g. TestARApp)
  @param _devName Developer Name
*/

/*!
 @abstract This is the entry-point to the Camera View which returns an instance of UIView. Use addPOI(s) before invoking this method.
 */
- (UIView*) start;

-(void) hide;
-(void) show;

// POI

/*!
 @abstract Add a single POI to the Camera View.
*/
- (void) addPOI: (WTPoi*) poi;

/*!
 @abstract Add multiple POIs to the Camera View.
 */
- (void) addPOIs: (NSArray*) pois;

/*!
 @abstract reload POIs in the Camera View.
 */
- (void) reloadPOIs: (NSArray*) pois;

/*!
 @abstract Remove a POI at the given list position from the Camera View.
 */
- (void) removePOIAtPosition: (int) position;


/*!
 @abstract Remove POI from the Camera View.
 */
- (void) removePOI: (WTPoi*) POI;




// MENU

/*!
 @abstract Add a menu item at the given position
 @param menuItem
 @param position The position parameter range is {1, 2, 3}, otherwise, an exception is thrown.
 */
- (void) addMenuItem: (WikitudeARCustomMenuButton*) menuItem
		  atPosition: (int) position;

/*!
 @abstract Remove the menu item at the given position
 @param position
 */
- (void) removeMenuItemAtPosition: (int) position;




// ADDITIONAL

/*!
 @abstract Show a default text in the top title bar of the Camera View.
 @param text 
 */
- (void) setTitleText: (NSString*) text;

/*!
 @abstract Show a default bitmap as the top title bar of the Camera View.
 @param image 
 */
- (void) setTitleBarImage: (id) image;

/*!
 @abstract Retrieve the number of already added POIs to the AR View.
 */
- (int) getPOIsSize;

/*!
 @abstract Retrieve the POI at the given position in the list of added POIs.
 @param position
 */
- (WTPoi*) getPoiAtPosition: (int) position;

/*!
 @abstract Retrieve all POIs already added to the AR View.
 */
- (NSArray*) getPOIs;

/*!
 @abstract Define whether the small preview-texts below the marker should be displayed.
 @param flag
 */
- (void) printMarkerSubText: (BOOL) flag;



@end
