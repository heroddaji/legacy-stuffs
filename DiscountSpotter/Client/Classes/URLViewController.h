//
//  URLViewController.h
//  trunk4
//
//  Created by ISAAC on 31-05-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface URLViewController : UIViewController {
    IBOutlet UIImageView *imageURL;   
	NSString *URL;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageURL;
@property (nonatomic, retain) NSString *URL;
-(IBAction)done;

@end
