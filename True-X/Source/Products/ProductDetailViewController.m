//
//  ProductDetailViewController.m
//  True-X
//
//  Created by Dao Nguyen on 5/12/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

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
    [self.mainScrollView setContentSize:CGSizeMake(320, 748)];
    self.pageLabel.text = @"1 of 4";
    self.productImageView.image = [UIImage imageNamed:@"ultrathin.png"];
    self.nameLabel.text = @"Ultrathin";
    self.descriptionLabel.text = @"Cảm giác thật";
    self.titleLabel.text = @"Nổi bật";
    self.contentTextView.text = @"Những người từng sử dụng True-X Ultra Thin cho biết, có đôi lúc, họ phải dừng lại kiểm tra xem mình có thật sự đang mang bao cao su không, bởi cảm giác đó quá chân thật. Và việc ngưng đột ngột ấy, giúp bạn lấy lại được bình tĩnh, kéo dài “hiệp đấu” và nàng thì phát điên vì bạn.";

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, 748)];
    
//    CGRect rect      = self.contentTextView.frame;
//    rect.size.height = self.contentTextView.contentSize.height;
//    self.contentTextView.frame   = rect;
//    
//    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.contentTextView.frame.origin.y + rect.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose ;of any resources that can be recreated.
}

@end
