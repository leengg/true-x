//
//  ProductDetailViewController.h
//  True-X
//
//  Created by InfoNam on 5/14/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailPageViewController.h"
#import "Products.h"

@interface ProductDetailViewController : UIViewController <ProductDetailPageDelegate>

@property (nonatomic, strong) Products *product;


- (IBAction)swipeLeft:(id)sender;
- (IBAction)swipeRight:(id)sender;

@end
