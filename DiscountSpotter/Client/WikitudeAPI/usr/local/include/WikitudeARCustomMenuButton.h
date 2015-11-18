
#import <Foundation/Foundation.h>
#import "WikitudeARCustomMenuButtonDelegate.h"

/*!
 @class WikitudeARCustomMenuButton
 @abstract Representation of CustomMenuButton
 
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


@interface WikitudeARCustomMenuButton : NSObject {
	NSString* text;
	id<WikitudeARCustomMenuButtonDelegate> delegate;
}

@property(assign, nonatomic) NSString* text; 
@property(assign, nonatomic) id<WikitudeARCustomMenuButtonDelegate> delegate; 

-(void) customMenuButtonPressed:(WTPoi*)currentSelectedPoi;
-(id) initWithText: (NSString*)text Delegate: (id<WikitudeARCustomMenuButtonDelegate>)delegate;

@end

