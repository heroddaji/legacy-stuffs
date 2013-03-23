//
//  Subscription.h
//  trunk4
//
//  Created by ISAAC on 09-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Subscription : NSObject {
	NSInteger shopID;
	NSString *productCategory;
}
@property(nonatomic,assign) NSInteger shopID;
@property(nonatomic,retain) NSString *productCategory;
@end
