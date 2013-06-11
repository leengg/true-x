//
//  ArticleDetailViewController.m
//  True-X
//
//  Created by Dao Nguyen on 5/12/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ArticleDetailViewController.h"

@interface ArticleDetailViewController ()

@end

@implementation ArticleDetailViewController

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
    
    // Setup title of navigation
    int categoryID = [self.article.att7_categoryID intValue];
    switch (categoryID) {
        case PhongDoID:
            self.navigationItem.title = @"Phong độ";
            break;
        case DangCapID:
            self.navigationItem.title = @"Đẳng cấp";
            break;
        case ChuyenBenLeID:
            self.navigationItem.title = @"Chuyện bên lề";
            break;
        case TuVanID:
            self.navigationItem.title = @"Tư vấn";
            break;
        default:
            break;
    }
    
    // Load article content
    //[self performSelector:@selector(loadArticleContent)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadArticleContent {
    
    NSString *headStyle = nil;
    
    if (IS_IPAD) {
        headStyle = [NSString stringWithFormat:@"<head><style type=\"text/css\"> body.center { display: block; margin-left: 50px; margin-right: 50px; } img {max-width: 650px !important;} img.center { display: block; margin-left: auto; margin-right: auto; }</style></head>"];
    }
    else {
        headStyle = [NSString stringWithFormat:@"<head><style type=\"text/css\"> body {max-width: 300px !important;} body.center { display: block; margin-left: auto; margin-right: auto; } img {max-width: 300px !important;} img.center { display: block; margin-left: auto; margin-right: auto; }</style></head>"];
    }
    
    NSString *titleHtmlString = [NSString stringWithFormat:@"<h2> %@ </h2>", self.article.att2_title];
    
    NSString *imageHtmlString = [NSString stringWithFormat:@"<img class=\"center\" alt=\"%@\" src=\"%@\"/>", self.article.att2_title, self.article.att3_thumbnailURL];

    NSString *htmlString = [NSString stringWithFormat:@"<html>%@<body class=\"center\"> %@ %@ %@</body></html>", headStyle, titleHtmlString, imageHtmlString, self.article.att5_contentHTML];

    [self.articleWebView loadHTMLString:htmlString baseURL:nil];
}

- (IBAction)clickBack:(id)sender {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickShare:(id)sender {
    
    NSDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                            self.article.att10_shareURL, @"link",
                            self.article.att3_thumbnailURL, @"picture",
                            self.article.att2_title, @"name",
                            IOS_APP_NAME, @"caption",
                            self.article.att4_descriptionText, @"description",
                            nil];

    [[TrueXFB shareTrueXFB] shareFB:params onViewController:self];
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
    NSLog(@"Frame: %f, %f", self.view.frame.size.width, self.view.frame.size.height);
    if([self interfaceOrientation] == UIInterfaceOrientationPortrait||[self interfaceOrientation] ==UIInterfaceOrientationPortraitUpsideDown)
    {
        if (IS_IPAD) {
            //set the frames for 9.5"(IPAD) screen here
            [self loadArticleContent];
        }
    }
    else if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft||[self interfaceOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        if (IS_IPAD) {
            //set the frames for 9.5"(IPAD) screen here
            [self loadArticleContent];
        }
    }
    else {
        [self loadArticleContent];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    //    customSegmentVC.view.hidden = NO;
    //    listArticlesVC.view.hidden = NO;
}

@end
