//
//  Subscription.m
//  trunk4
//
//  Created by ISAAC on 09-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Subscription.h"


@implementation Subscription

@synthesize shopID;
@synthesize productCategory;

-(void)dealloc{
	[productCategory release];
	
	[super dealloc];
}
@end
