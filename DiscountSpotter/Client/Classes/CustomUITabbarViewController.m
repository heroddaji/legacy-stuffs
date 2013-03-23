//
//  CustomUITabbarViewController.m
//  trunk4
//
//  Created by dai on 7/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomUITabbarViewController.h"


@implementation UITabBar (CustomImage)
- (void)drawRect:(CGRect)rect {
   UIImage *image = [UIImage imageNamed: @"bottom_blue.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end


@implementation CustomUITabbarViewController
@synthesize colorTabbar;


- (void)viewDidLoad {
	[super viewDidLoad];
	
//self.colorTabbar.backgroundColor = [UIColor blueColor];
	//[self.colorTabbar setBackgroundColor:[UIColor redColor]];
	
	//UIImage *myImage = [[UIImage imageNamed:@"tabbar_background.png"] retain];
	//UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
	
	//[self.colorTabbar addSubview:imageView];
	//[imageView release];
}

@end



