//
//  ProductDetailViewController.m
//  True-X
//
//  Created by InfoNam on 5/14/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EGOQuickPhoto.h"

@interface ProductDetailViewController ()

@property int currentPage;
@property (nonatomic, strong) ProductDetailPageViewController *currentProductDetailPageVC;
@property (nonatomic, strong) ProductDetailPageViewController *nextProductDetailPageVC;
@property (nonatomic, strong) ProductDetailPageViewController *previewProductDetailPageVC;

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
    self.currentPage = FirstPage;
    self.currentProductDetailPageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailPageViewControllerID"];
    self.currentProductDetailPageVC.product = self.product;

    self.currentProductDetailPageVC.delegate = self;
    self.currentProductDetailPageVC.currentPage = self.currentPage;
    NSLog(@"Ogrinal: %f, %f", self.view.frame.origin.x, self.view.frame.origin.y);
    [self.view addSubview:self.currentProductDetailPageVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swipeLeft:(id)sender {
    
    NSLog(@"Swipe Left: %@", [sender description]);
    if (self.currentPage < FourthPage) {
        
        [self gotoNextPage];
    }
    else {
        
    }
}

- (IBAction)swipeRight:(id)sender {
    
    NSLog(@"Swipe Right: %@", [sender description]);
    if (self.currentPage > FirstPage) {
        
        [self gotoPreviewPage];
    }
    else {
        
    }
}

- (IBAction)clickBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickShare:(id)sender {
    
    NSDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                            self.product.att8_shareURL, @"link",
                            self.product.att5_thumbnailURL, @"picture",
                            self.product.att3_categoryName, @"name",
                            IOS_APP_NAME, @"caption",
                            self.product.att4_description, @"description",
                            nil];
    
    [[TrueXFB shareTrueXFB] shareFB:params onViewController:self];
}

#pragma mark - ProductDetailPageDelegate

- (void)didChangePage:(ProductDetailPageViewController *)productDetailPageVC withDirection:(PagingDirection)direction {
    
    if (direction == NextPage && self.currentPage < FourthPage) {

        [self gotoNextPage];
    }
    else if (direction == PreviewPage && self.currentPage > FirstPage) {
        
        [self gotoPreviewPage];
    }
    else {
        
    }
}

- (void)didTapPhotoViewer:(ProductDetailPageViewController *)productDetailPageVC {

    NSSortDescriptor *sortRule = [[NSSortDescriptor alloc] initWithKey:@"att1_id" ascending:YES];
    NSArray *slides = [self.product.slide sortedArrayUsingDescriptors:[[NSArray alloc] initWithObjects:sortRule, nil]];
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:slides.count];
    for (int i = 0; i < slides.count; i++) {
        ProductSlides *pSlide = (ProductSlides *)[slides objectAtIndex:i];
        EGOQuickPhoto *photo = [[EGOQuickPhoto alloc] initWithImageURL:[NSURL URLWithString:pSlide.att4_thumbnailURL] name:nil];
        [images addObject:photo];
    }
    EGOQuickPhotoSource *source = [[EGOQuickPhotoSource alloc] initWithPhotos:images];
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    [photoController setCurrentPhotoIndex:self.currentPage-1];
    [self.navigationController pushViewController:photoController animated:YES];
}

#pragma mark - Paging Product

- (void)gotoNextPage {
    
    self.currentPage++;
    self.previewProductDetailPageVC = self.currentProductDetailPageVC;
    self.currentProductDetailPageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailPageViewControllerID"];
    self.currentProductDetailPageVC.product = self.product;
    self.currentProductDetailPageVC.delegate = self;
    self.currentProductDetailPageVC.currentPage = self.currentPage;
    self.currentProductDetailPageVC.isHackScrollView = YES;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush; //choose your animation
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:nil];
    [self.previewProductDetailPageVC.view removeFromSuperview];
    [self.view addSubview:self.currentProductDetailPageVC.view];
}

- (void)gotoPreviewPage {
    
    self.currentPage--;
    self.nextProductDetailPageVC = self.currentProductDetailPageVC;
    self.currentProductDetailPageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailPageViewControllerID"];
    self.currentProductDetailPageVC.product = self.product;
    self.currentProductDetailPageVC.delegate = self;
    self.currentProductDetailPageVC.currentPage = self.currentPage;
    self.currentProductDetailPageVC.isHackScrollView = YES;    

    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionPush; //choose your animation
    transition.subtype = kCATransitionFromLeft; 
    [self.view.layer addAnimation:transition forKey:nil];
    [self.nextProductDetailPageVC.view removeFromSuperview];
    [self.view addSubview:self.currentProductDetailPageVC.view];
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
            [self.currentProductDetailPageVC doRotationToFrame:self.view.frame];
        }
    }
    else if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft||[self interfaceOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        if (IS_IPAD) {
            //set the frames for 9.5"(IPAD) screen here
            [self.currentProductDetailPageVC doRotationToFrame:self.view.frame];
        }
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    //    customSegmentVC.view.hidden = NO;
    //    listArticlesVC.view.hidden = NO;
}

@end
