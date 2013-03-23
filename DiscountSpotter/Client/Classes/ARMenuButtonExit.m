//
//  ARMenuButtonExit.m
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 21-05-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#if !TARGET_IPHONE_SIMULATOR

#import "ARMenuButtonExit.h"
#import "AugmentedRealityISAACAppDelegate.h"
#import "WikitudeARViewController.h"

@implementation ARMenuButtonExit

-(void) customMenuButtonPressed:(WTPoi*)currentSelectedPoi {
	
	AugmentedRealityISAACAppDelegate *appdel = (AugmentedRealityISAACAppDelegate *)[[UIApplication sharedApplication]delegate];
	
	[[WikitudeARViewController sharedInstance] hide];
}



@end

#endif