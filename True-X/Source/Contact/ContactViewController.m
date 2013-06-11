//
//  ContactViewController.m
//  True-X
//
//  Created by InfoNam on 5/29/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ContactViewController.h"

static NSString *kSchemeEmailToTrueX = @"mailto:info@true-x.net";

@interface ContactViewController ()

@end

@implementation ContactViewController

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
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 480-20);
    }
    else
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 568-20);
    }
    
//    [self loadContentHMTL];
}

- (void)loadContentHMTL {
    
    NSString *logoPath = [[NSBundle mainBundle] pathForResource:@"true_x_logo" ofType:@"png"];
    
    NSString *emailButtonPath = nil;
    if (IS_IPAD) {
        emailButtonPath = [[NSBundle mainBundle] pathForResource:@"bg_email_button_ipad" ofType:@"png"];
    }
    else {
        emailButtonPath = [[NSBundle mainBundle] pathForResource:@"bg_email_button" ofType:@"png"];
    }
    
    NSString *imageHtmlString = [NSString stringWithFormat:@"<img class=\"center\" alt=\"%@\" src=\"file://%@\" style=\"width: 240px;\" />", @"True-X", logoPath];
    NSString *contentHMLT = [NSString stringWithFormat:@"<p><h3>Văn Phòng Giao Dịch True-X </h3>Địa chỉ: 45/25/5 Nguyễn Văn Đậu, P. 6, Q. Bình Thạnh, TP.HCM.</br>Điện thoại: 083-841-0945 - 0120-7667-888</br>Fax: 083-841-0946</br>Email: info@true-x.net</br>Website: <a href=\"http://true-x.net\">http://true-x.net</a></br></br>Nhãn hiệu True-X thuộc sở hữu của Công Ty Maple Limited - Japan.</br>6-chome 14-8 Tsukiji, Chuo-ku Tokyo, Japan 104-0045</br>Sản phẩm được sản xuất tại Malaysia dưới sự giám sát của True-X</br>VPĐD tại Châu Âu: Advena Ltd. Hereford, HR4 9DQ. United Kingdom.</br>VPĐD tại Việt Nam: Hanh An Trading Service Co., Ltd.</br></p><p> <br/> <a href=\"%@\" target=\"_blank\"><img class=\"center\" src=\"file://%@\" style=\"border: 0;\" /></a></p>", kSchemeEmailToTrueX, emailButtonPath];
    
    NSString *headStyle = nil;
    
    if (IS_IPAD) {
        headStyle = [NSString stringWithFormat:@"<head><style type=\"text/css\"> body {font-family:\"Helvetica\"; font-size:24px;color:#FFF;} body.center { display: block; margin-left: 50px; margin-right: 50px; } img {max-width: 650px !important;} img.center { display: block; margin-left: auto; margin-right: auto; } a { color:#1288f0;}</style></head>"];
    }
    else {
        headStyle = [NSString stringWithFormat:@"<head><style type=\"text/css\"> body {font-family:\"Helvetica\"; font-size:14px;color:#FFF;} body.center { display: block; margin-left: 10px; margin-right: 10px; } img {max-width: 300px !important;} img.center { display: block; margin-left: auto; margin-right: auto; } a { color:#1288f0;}</style></head>"];
    }
    
    NSString *htmlString = [NSString stringWithFormat:@"<html>%@<body class=\"center\"> <br/><br/> %@ <br/> %@<br/></body></html>", headStyle, imageHtmlString, contentHMLT];
    
    [self.contactTextView loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContactTextView:nil];
    [super viewDidUnload];
}

#pragma mark - UIWebviewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *scheme = request.URL.scheme;
    if ([scheme isEqualToString:@"mailto"] || [scheme isEqualToString:@"tel"] || [scheme isEqualToString:@"http"])
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    else    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"page is loading");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"finished loading");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"error loading");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - iOS5 & 6 Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //    customSegmentVC.view.hidden = YES;
    //    listArticlesVC.view.hidden = YES;
}

-(void)viewWillLayoutSubviews
{
    if([self interfaceOrientation] == UIInterfaceOrientationPortrait||[self interfaceOrientation] ==UIInterfaceOrientationPortraitUpsideDown)
    {
        if (IS_IPAD) {
            //set the frames for 9.5"(IPAD) screen here
            [self loadContentHMTL];
            self.contactTextView.frame = self.view.frame;
        }
    }
    else if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft||[self interfaceOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        if (IS_IPAD) {
            //set the frames for 9.5"(IPAD) screen here
            [self loadContentHMTL];
            self.contactTextView.frame = self.view.frame;
        }
    }
    else {
        [self loadContentHMTL];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    //    customSegmentVC.view.hidden = NO;
    //    listArticlesVC.view.hidden = NO;
}

@end
