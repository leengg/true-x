//
//  HomeArticlesViewController.m
//  True-X
//
//  Created by Dao Nguyen on 5/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "HomeArticlesViewController.h"
#import "Articles.h"
#import "ArticleDetailViewController.h"
#import "UIRotationManager.h"

@interface CategoryPosition : NSObject {

}

@property CGPoint phongDoPosition;
@property CGPoint dangCapPosition;
@property CGPoint chuyenBenLePosition;
@property CGPoint tuVanPosition;

@property int phongDoPage;
@property int dangCapPage;
@property int chuyenBenLePage;
@property int tuVanPage;

@end

@implementation CategoryPosition

@end

@interface HomeArticlesViewController () {
    
    CustomSegmentViewController *customSegmentVC;
    ListArticlesViewController *listArticlesVC;
    CategoryPosition *categoryPosition;
}

@end

@implementation HomeArticlesViewController

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
    
    categoryPosition = [[CategoryPosition alloc] init];
    categoryPosition.phongDoPage = 1;
    categoryPosition.dangCapPage = 1;
    categoryPosition.chuyenBenLePage = 1;
    categoryPosition.tuVanPage = 1;

    [ArticlesModel shareArticlesModel].currentCatoryID = PhongDoID;
    [ArticlesModel shareArticlesModel].currentPage = categoryPosition.phongDoPage;
    
    listArticlesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ListArticlesViewControllerID"];
    listArticlesVC.delegate = self;
    [self.view addSubview:listArticlesVC.view];    

    if (!IS_IPAD) {
        customSegmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomSegmentViewControllerID"];
        customSegmentVC.delegate = self;
        [self.view addSubview:customSegmentVC.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickReload:(id)sender {
    
    [[ArticlesModel shareArticlesModel] setCurrentPage:1];
    listArticlesVC.currentContentOffset = CGPointZero;
    [self saveCurrentCagetoryPosition];

    [[ArticlesModel shareArticlesModel] getArticlesList:YES];
}

- (void)saveCurrentCagetoryPosition {
    
    CategoryID categoryID = [ArticlesModel shareArticlesModel].currentCatoryID;
    switch (categoryID) {
        case PhongDoID:
            categoryPosition.phongDoPosition = listArticlesVC.listArticlesTableView.contentOffset;
            categoryPosition.phongDoPage = [ArticlesModel shareArticlesModel].currentPage;
            break;
        case DangCapID:
            categoryPosition.dangCapPosition = listArticlesVC.listArticlesTableView.contentOffset;
            categoryPosition.dangCapPage = [ArticlesModel shareArticlesModel].currentPage;
            break;
        case ChuyenBenLeID:
            categoryPosition.chuyenBenLePosition = listArticlesVC.listArticlesTableView.contentOffset;
            categoryPosition.chuyenBenLePage = [ArticlesModel shareArticlesModel].currentPage;
            break;
        case TuVanID:
            categoryPosition.tuVanPosition = listArticlesVC.listArticlesTableView.contentOffset;
            categoryPosition.tuVanPage = [ArticlesModel shareArticlesModel].currentPage;
            break;
        default:
            break;
    }
}

#pragma mark - CustomSegmentDelegate

- (void)customSegment:(CustomSegmentViewController *)customSegmentVC didSelectIndex:(int)index {
    
    [self saveCurrentCagetoryPosition];
    
    switch (index) {
        case 0:
            listArticlesVC.currentContentOffset = categoryPosition.phongDoPosition;
            [[ArticlesModel shareArticlesModel] setCurrentCatoryID:PhongDoID];
            [[ArticlesModel shareArticlesModel] setCurrentPage:categoryPosition.phongDoPage];
            [[ArticlesModel shareArticlesModel] getArticlesList:NO];
            break;
        case 1:
            listArticlesVC.currentContentOffset = categoryPosition.dangCapPosition;
            [[ArticlesModel shareArticlesModel] setCurrentCatoryID:DangCapID];
            [[ArticlesModel shareArticlesModel] setCurrentPage:categoryPosition.dangCapPage];
            [[ArticlesModel shareArticlesModel] getArticlesList:NO];
            break;
        case 2:
            listArticlesVC.currentContentOffset = categoryPosition.chuyenBenLePosition;
            [[ArticlesModel shareArticlesModel] setCurrentCatoryID:ChuyenBenLeID];
            [[ArticlesModel shareArticlesModel] setCurrentPage:categoryPosition.chuyenBenLePage];
            [[ArticlesModel shareArticlesModel] getArticlesList:NO];
            break;
        case 3:
            listArticlesVC.currentContentOffset = categoryPosition.tuVanPosition;
            [[ArticlesModel shareArticlesModel] setCurrentCatoryID:TuVanID];
            [[ArticlesModel shareArticlesModel] setCurrentPage:categoryPosition.tuVanPage];
            [[ArticlesModel shareArticlesModel] getArticlesList:NO];
            break;
        default:
            break;
    }
}

#pragma mark - ListArticlesDelegate

- (void)didSelectListArticles:(ListArticlesViewController *)listArticlesVC atIndexPath:(NSIndexPath *)index {

    UIStoryboard *storyboard = nil;
    if (IS_IPAD) {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard-iPad" bundle:nil];
    }
    else {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard-iPhone" bundle:nil];
    }
    ArticleDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"ArticleDetailViewControllerID"];
    detailViewController.article = [[ArticlesModel shareArticlesModel].currentArticlesList objectAtIndex:index.row];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didScrollToBottom:(ListArticlesViewController *)listArticlesVC atIndexPage:(int)index {

    NSLog(@"Call %d", index);
    [[ArticlesModel shareArticlesModel] setCurrentPage:index];
    [[ArticlesModel shareArticlesModel] getArticlesList:YES];
}

#pragma mark - iOS5 & 6 Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [[UIRotationManager sharedInstance] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [[UIRotationManager sharedInstance] supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [[UIRotationManager sharedInstance] shouldAutorotate];
}

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
            listArticlesVC.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 73, self.view.frame.size.width, self.view.frame.size.height - 72);
            
            int currentIndex = [customSegmentVC getCurrentIndex];
            customSegmentVC.delegate = nil;
            [customSegmentVC.view removeFromSuperview];
            
            customSegmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomSegmentViewControllerPortraitID"];
            customSegmentVC.delegate = self;
            [self.view addSubview:customSegmentVC.view];
            [customSegmentVC selectIndex:currentIndex];
        }
    }
    else if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft||[self interfaceOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        if (IS_IPAD) {
            //set the frames for 9.5"(IPAD) screen here
            listArticlesVC.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 73, self.view.frame.size.width, self.view.frame.size.height - 72);
            
            int currentIndex = [customSegmentVC getCurrentIndex];
            customSegmentVC.delegate = nil;
            [customSegmentVC.view removeFromSuperview];
            
            customSegmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomSegmentViewControllerLandscapeID"];
            customSegmentVC.delegate = self;
           [self.view addSubview:customSegmentVC.view];
            [customSegmentVC selectIndex:currentIndex];
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
