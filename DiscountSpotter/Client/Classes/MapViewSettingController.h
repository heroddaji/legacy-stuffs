//
//  MapViewSettingController.h
//  trunk4
//
//  Created by ISAAC on 29-06-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MapViewSettingController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableViewCell *Cell1;
	IBOutlet UITableViewCell *Cell2;
}
@property(nonatomic,retain) IBOutlet UITableViewCell *Cell1;
@property(nonatomic,retain) IBOutlet UITableViewCell *Cell2;

-(IBAction)back;

@end
