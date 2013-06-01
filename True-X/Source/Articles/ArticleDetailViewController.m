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
    [self performSelector:@selector(loadArticleContent)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadArticleContent {
    
    NSString *titleHtmlString = [NSString stringWithFormat:@"<h2> %@ </h2>", self.article.att2_title];
    NSString *imageHtmlString = [NSString stringWithFormat:@"<img alt=\"%@\" src=\"%@\" style=\"width: 304px;\" />", self.article.att2_title, self.article.att3_thumbnailURL];
    NSString *headStyle = [NSString stringWithFormat:@"<head><style type=\"text/css\">img {width: 304px !important;}</style></head>"];
    NSString *htmlString = [NSString stringWithFormat:@"<html>%@<body style='font-family:\"Tahoma\";'> %@ %@ %@</body></html>", headStyle, titleHtmlString, imageHtmlString, self.article.att5_contentHTML];

    [self.articleWebView loadHTMLString:htmlString baseURL:nil];
}

- (IBAction)clickBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickShare:(id)sender {
    
    NSDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                            @"http://true-x.net", @"link",
                            self.article.att3_thumbnailURL, @"picture",
                            self.article.att2_title, @"name",
                            IOS_APP_NAME, @"caption",
                            self.article.att4_descriptionText, @"description",
                            nil];

    [[TrueXFB shareTrueXFB] shareFB:params onViewController:self];
}


#pragma mark - UIWebviewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
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

@end
