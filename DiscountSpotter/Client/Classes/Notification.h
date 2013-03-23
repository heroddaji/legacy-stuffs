//
//  Notification.h
//  trunk4
//
//  Created by ISAAC on 09-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Notification : NSObject {
	NSInteger shopID;
	NSInteger couponID;
}
@property(nonatomic,assign) NSInteger shopID;
@property(nonatomic,assign) NSInteger couponID;


@end
