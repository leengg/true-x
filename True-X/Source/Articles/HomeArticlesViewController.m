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

    customSegmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomSegmentViewControllerID"];
    customSegmentVC.delegate = self;
    [self.view addSubview:customSegmentVC.view];
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

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard-iPhone" bundle:nil];
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

@end
