//
//  loadingEffectView.h
//  dummy
//
//  Created by ISAAC on 09-07-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EffectView : UIView
{
	
}
+ (id)loadingViewInView:(UIView *)aSuperview;
- (void)removeView;

@end


@interface LoadingEffectView : UIViewController {
	UILabel *loadingLabel;
	NSString *message;
}
@property (nonatomic,retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic,retain) NSString *message;

@end
