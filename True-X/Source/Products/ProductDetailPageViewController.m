//
//  ProductDetailPageViewController.m
//  True-X
//
//  Created by InfoNam on 5/15/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ProductDetailPageViewController.h"

@interface ProductDetailPageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation ProductDetailPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if( !IS_IPHONE_5 )
    {
        if (self.isHackScrollView) {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 480-20-44-49);
        }
        else {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 480-20);
        }
    }
    else
    {
        if (self.isHackScrollView) {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 568-20-44-49);
        }
        else {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 568-20);
        }
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"att1_id == %d AND att5_productID == %@", self.currentPage, self.product.att1_id];
    ProductSlides *productSlide = [ProductSlides findFirstWithPredicate:predicate];
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d of 4", productSlide.att1_id];     //[NSString stringWithFormat:@"%d of 4", self.currentPage];
    [self.productImageView setImageWithURL:[NSURL URLWithString:productSlide.att4_thumbnailURL] placeholderImage:[UIImage imageNamed:@"placehold.png"]];
    self.productNameLabel.text = self.product.att3_categoryName;   //@"Ultrathin";
    self.productFeelingLabel.text = self.product.att4_description;  //@"Cảm giác thật";
    
    self.productTitleLabel.text = productSlide.att2_name;
    self.productDescriptionTextView.text = productSlide.att3_description; // @"1. Những người từng sử dụng True-X Ultra Thin cho biết, có đôi lúc, họ phải dừng lại kiểm tra xem mình có thật sự đang mang bao cao su không, bởi cảm giác đó quá chân thật. Và việc ngưng đột ngột ấy, giúp bạn lấy lại được bình tĩnh, kéo dài “hiệp đấu” và nàng thì phát điên vì bạn.";
    
    CGRect frame = self.productDescriptionTextView.frame;
    frame.size.height = self.productDescriptionTextView.contentSize.height + 20;
    self.productDescriptionTextView.frame = frame;
    
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.productDescriptionTextView.frame.origin.y + self.productDescriptionTextView.frame.size.height)];
    
    if (self.currentPage == FirstPage) {
        self.leftBtn.enabled = NO;
    }
    if  (self.currentPage == FourthPage) {
        self.rightBtn.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPageLabel:nil];
    [self setProductImageView:nil];
    [self setProductNameLabel:nil];
    [self setProductFeelingLabel:nil];
    [self setProductDescriptionTextView:nil];
    [self setMainScrollView:nil];
    [self setProductTitleLabel:nil];
    [super viewDidUnload];
}

- (IBAction)clickNext:(id)sender {
    
    [self.delegate didChangePage:self withDirection:NextPage];
}

- (IBAction)clickPreview:(id)sender {

    [self.delegate didChangePage:self withDirection:PreviewPage];
}




@end
