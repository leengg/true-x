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
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }
    else
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.pageLabel.text = [NSString stringWithFormat:@"%d of 4", self.currentPage];
    self.productImageView.image = [UIImage imageNamed:@"ultrathin.png"];
    self.productNameLabel.text = @"Ultrathin";
    self.productFeelingLabel.text = @"Cảm giác thật";
    self.productDescriptionTextView.text = @"1. Những người từng sử dụng True-X Ultra Thin cho biết, có đôi lúc, họ phải dừng lại kiểm tra xem mình có thật sự đang mang bao cao su không, bởi cảm giác đó quá chân thật. Và việc ngưng đột ngột ấy, giúp bạn lấy lại được bình tĩnh, kéo dài “hiệp đấu” và nàng thì phát điên vì bạn.";
    
    CGRect frame = self.productDescriptionTextView.frame;
    frame.size.height = self.productDescriptionTextView.contentSize.height + 20;
    NSLog(@"TextView's Frame: %f, %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    self.productDescriptionTextView.frame = frame;
    
    CGSize size = self.mainScrollView.contentSize;
    frame = self.mainScrollView.frame;
    NSLog(@"ScrollView's contentSize: %f, %f", size.width, size.height);
    NSLog(@"ScrollView's frame: %f, %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);

    [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.productDescriptionTextView.frame.origin.y + self.productDescriptionTextView.frame.size.height)];
    size = self.mainScrollView.contentSize;
    frame = self.mainScrollView.frame;
    NSLog(@"ScrollView's contentSize: %f, %f", size.width, size.height);
    NSLog(@"ScrollView's frame: %f, %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);

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
    [super viewDidUnload];
}

- (IBAction)clickNext:(id)sender {
    
    [self.delegate didChangePage:self withDirection:NextPage];
}

- (IBAction)clickPreview:(id)sender {

    [self.delegate didChangePage:self withDirection:PreviewPage];
}


@end
