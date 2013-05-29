//
//  ProductDetailPageViewController.h
//  True-X
//
//  Created by InfoNam on 5/15/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Products.h"
#import "ProductSlides.h"
#import "UIImageView+AFNetworking.h"

@class ProductDetailPageViewController;

@protocol ProductDetailPageDelegate <NSObject>

@required
- (void)didChangePage:(ProductDetailPageViewController *)productDetailPageVC withDirection:(PagingDirection)direction;
- (void)didTapPhotoViewer:(ProductDetailPageViewController *)productDetailPageVC;

@end

@interface ProductDetailPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *productFeelingLabel;
@property (strong, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *productDescriptionTextView;

@property (nonatomic, strong) Products *product;

@property (nonatomic, weak) id <ProductDetailPageDelegate> delegate;
@property int currentPage;
@property BOOL isHackScrollView;

@end
