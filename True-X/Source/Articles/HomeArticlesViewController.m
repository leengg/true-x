//
//  HomeArticlesViewController.m
//  True-X
//
//  Created by Dao Nguyen on 5/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "HomeArticlesViewController.h"
#import "Articles.h"
#import "ArticlesCategories.h"
#import "ArticleDetailViewController.h"

@interface HomeArticlesViewController () {
    
    CustomSegmentViewController *customSegmentVC;
    ListArticlesViewController *listArticlesVC;
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
    customSegmentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomSegmentViewControllerID"];
    customSegmentVC.delegate = self;
    [self.view addSubview:customSegmentVC.view];
    
    listArticlesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ListArticlesViewControllerID"];
    listArticlesVC.delegate = self;
    [self.view addSubview:listArticlesVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomSegmentDelegate

- (void)customSegment:(CustomSegmentViewController *)customSegmentVC didSelectIndex:(int)index {
    
}

#pragma mark - ListArticlesDelegate

- (void)didSelectListArticles:(ListArticlesViewController *)listArticlesVC atIndexPath:(NSIndexPath *)index {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard-iPhone" bundle:nil];
    ArticleDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"ArticleDetailViewControllerID"];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
