//
//  Coupon.h
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 10-05-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CouponDelegate;

@interface Coupon : NSObject {
	
	//discount product
	NSString *productName;
	NSString *productDescription;
	NSString *productBrand;
	NSString *productCategory;
	float productPrice;
	NSString *productImage;
	
	NSInteger couponID;
	NSString *discountDescription;
	NSString *discountType;
	float discountValue;
	float discountPrice;
	NSDate *fromDate;
	NSDate *toDate;
	
	NSString *barcode;
	NSInteger shopID;
	NSInteger remainDays;
	NSString *status;
	
	BOOL isProductCategorySubscribed;
	
	//some addition ivar used for download image
	NSIndexPath *theIndexPath;
	UIImage *downloadImage;
	NSMutableData *activeDownload;
	id <CouponDelegate> delegate;
	
}

@property(nonatomic,retain) NSString *productName;
@property(nonatomic,retain) NSString *productDescription;
@property(nonatomic,retain) NSString *productBrand;
@property(nonatomic,retain) NSString *productCategory;
@property(nonatomic,assign) float productPrice;
@property(nonatomic,retain) NSString *productImage;

@property(nonatomic,assign) NSInteger couponID;
@property(nonatomic,retain) NSString *discountDescription;
@property(nonatomic,retain) NSString *discountType;
@property(nonatomic,assign) float discountValue;
@property(nonatomic,assign) float discountPrice;
@property(nonatomic,retain) NSDate *fromDate;
@property(nonatomic,retain) NSDate *toDate;

@property(nonatomic,retain) NSString *barcode;
@property(nonatomic,assign) NSInteger shopID;
@property(nonatomic,assign) NSInteger remainDays;
@property(nonatomic,retain) NSString *status;
@property(nonatomic,assign) BOOL isProductCategorySubscribed;


@property(nonatomic,retain) NSIndexPath *theIndexPath;
@property(nonatomic,retain) UIImage *downloadImage;
@property(nonatomic,retain) NSMutableData *activeDownload;
@property(nonatomic,retain) id <CouponDelegate> delegate;



-(float)getDiscountPrice;
-(void)getImageFromProductImageLink;
@end

@protocol CouponDelegate

-(void)couponImageFinishDownloadFrom:(Coupon *)theCoupon withIndexPath:(NSIndexPath *)indexPath;

@end

