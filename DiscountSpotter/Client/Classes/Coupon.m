//
//  Coupon.m
//  AugmentedRealityISAAC
//
//  Created by ISAAC on 10-05-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Coupon.h"


@implementation Coupon

//discount product
@synthesize productName;
@synthesize productDescription;
@synthesize productBrand;
@synthesize productCategory;
@synthesize productPrice;
@synthesize productImage;

@synthesize couponID;
@synthesize discountDescription;
@synthesize discountType;
@synthesize discountValue;
@synthesize discountPrice;
@synthesize fromDate;
@synthesize toDate;
@synthesize barcode;
@synthesize shopID;
@synthesize remainDays;
@synthesize status;
@synthesize isProductCategorySubscribed;

@synthesize theIndexPath;
@synthesize downloadImage;
@synthesize activeDownload;
@synthesize delegate;

-(float)getDiscountPrice{
	discountPrice = 0;
	if (discountType != nil) {
		if ([discountType isEqualToString:@"percentage"]) {
			discountPrice = productPrice * (1 - discountValue);
		}
		
		if ([discountType isEqualToString:@"absolute off"]) {
			discountPrice = productPrice - discountValue;
		}
		
		if ([discountType isEqualToString:@"absolute value"]) {
			discountPrice = discountValue;
		}
	}
	
	NSAssert1(discountPrice > 0,@"NSAssert1 caught, discount price is not set properly",discountPrice);
	return discountPrice;
}

-(void)getImageFromProductImageLink{
	
	activeDownload = [[NSMutableData alloc] init];
	
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:productImage]] delegate:self];
	[conn start];
}

//download image support
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   
	downloadImage = [[UIImage alloc] initWithData:activeDownload];
    
    self.activeDownload = nil;
    
    [delegate couponImageFinishDownloadFrom:self withIndexPath:theIndexPath];
}

-(void)dealloc{
	[productName release];
	[productDescription release];
	[productBrand release];
	[productCategory release];
	[productImage release];
	
	[discountDescription release];
	[discountType release];
	[fromDate release];
	[toDate release];
	[barcode release];
	[status release];
	
	[theIndexPath release];
	[downloadImage release];
	[activeDownload release];
	[super dealloc];
}

@end
