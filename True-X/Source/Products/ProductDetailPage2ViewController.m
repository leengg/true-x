//
//  ProductDetailPage2ViewController.m
//  True-X
//
//  Created by InfoNam on 5/15/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ProductDetailPage2ViewController.h"

@interface ProductDetailPage2ViewController ()

@end

@implementation ProductDetailPage2ViewController

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
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 460);
    }
    self.pageLabel.text = @"1 of 4";
    self.productImageView.image = [UIImage imageNamed:@"ultrathin.png"];
    self.productNameLabel.text = @"Ultrathin";
    self.productFeelingLabel.text = @"Cảm giác thật";
    self.productDescriptionTextView.text = @"1. Những người từng sử dụng True-X Ultra Thin cho biết, có đôi lúc, họ phải dừng lại kiểm tra xem mình có thật sự đang mang bao cao su không, bởi cảm giác đó quá chân thật. Và việc ngưng đột ngột ấy, giúp bạn lấy lại được bình tĩnh, kéo dài “hiệp đấu” và nàng thì phát điên vì bạn. 2. Những người từng sử dụng True-X Ultra Thin cho biết, có đôi lúc, họ phải dừng lại kiểm tra xem mình có thật sự đang mang bao cao su không, bởi cảm giác đó quá chân thật. Và việc ngưng đột ngột ấy, giúp bạn lấy lại được bình tĩnh, kéo dài “hiệp đấu” và nàng thì phát điên vì bạn. 3. Những người từng sử dụng True-X Ultra Thin cho biết, có đôi lúc, họ phải dừng lại kiểm tra xem mình có thật sự đang mang bao cao su không, bởi cảm giác đó quá chân thật. Và việc ngưng đột ngột ấy, giúp bạn lấy lại được bình tĩnh, kéo dài “hiệp đấu” và nàng thì phát điên vì bạn. 4. Những người từng sử dụng True-X Ultra Thin cho biết, có đôi lúc, họ phải dừng lại kiểm tra xem mình có thật sự đang mang bao cao su không, bởi cảm giác đó quá chân thật. Và việc ngưng đột ngột ấy, giúp bạn lấy lại được bình tĩnh, kéo dài “hiệp đấu” và nàng thì phát điên vì bạn. 5. Những người từng sử dụng True-X Ultra Thin cho biết, có đôi lúc, họ phải dừng lại kiểm tra xem mình có thật sự đang mang bao cao su không, bởi cảm giác đó quá chân thật. Và việc ngưng đột ngột ấy, giúp bạn lấy lại được bình tĩnh, kéo dài “hiệp đấu” và nàng thì phát điên vì bạn.";
    
    CGRect frame = self.productDescriptionTextView.frame;
    frame.size.height = self.productDescriptionTextView.contentSize.height + 20;
    self.productDescriptionTextView.frame = frame;
    
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.productDescriptionTextView.frame.origin.y + self.productDescriptionTextView.frame.size.height)];
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
    [super viewDidUnload];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ((orientation == UIInterfaceOrientationPortrait) ||
        (orientation == UIInterfaceOrientationLandscapeLeft))
        return YES;
    
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

@end
