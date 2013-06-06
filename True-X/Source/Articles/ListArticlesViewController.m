//
//  ListArticlesViewController.m
//  True-X
//
//  Created by Dao Nguyen on 5/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ListArticlesViewController.h"
#import "ArticleCell.h"
#import "UIImageView+AFNetworking.h"
//#import "UIImageView+WebCache.h"

//dispatch_queue_t taskQ;

@interface ListArticlesViewController () {

    BOOL canLoadMore;
}

@end

@implementation ListArticlesViewController

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
    self.currentContentOffset = CGPointZero;

    if (IS_IPAD) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 72, self.view.frame.size.width, 1024-20-44-49 - 72);
    }
    else if( !IS_IPHONE_5 )
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 38, self.view.frame.size.width, 480-20 - 38);
    }
    else
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 38, self.view.frame.size.width, 568-20 - 38);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListArticlesTableView:) name:NOTIFICATION_ARTICLE_DID_FINISH_LOAD object:nil];
        
//    taskQ = dispatch_queue_create("net.true-x.love&sex", DISPATCH_QUEUE_SERIAL);
}

- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateListArticlesTableView:(NSNotification *)notification {

    NSLog(@"updateListArticlesTableView with count: %d", [ArticlesModel shareArticlesModel].currentArticlesList.count);
    self.listArticlesTableView.hidden = ([ArticlesModel shareArticlesModel].currentArticlesList.count == 0) ? YES : NO;

    [self.listArticlesTableView reloadData];
    canLoadMore = [notification.object boolValue];
    if (!self.listArticlesTableView.hidden) {
        [self.listArticlesTableView setContentOffset:self.currentContentOffset animated:NO];
    }
}

- (void)performLoadMoreArticles {
    
    if (canLoadMore) {
        canLoadMore = NO;
        self.currentContentOffset = self.listArticlesTableView.contentOffset;
        [self.delegate didScrollToBottom:self atIndexPage:[ArticlesModel shareArticlesModel].currentPage+1];
    }
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
//    dispatch_release(taskQ);
}

- (void)scrollToTop {
    
    [self.listArticlesTableView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ArticlesModel shareArticlesModel].currentArticlesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCellID";
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    Articles *article = (Articles *)[[[ArticlesModel shareArticlesModel] currentArticlesList] objectAtIndex:indexPath.row];

    cell.titleTextView.text = article.att2_title;
    
    //Using UIImageView of AFNetworking
    [cell.thumbnailImageView setThumbnailImageWithURL:[NSURL URLWithString:article.att3_thumbnailURL] placeholderImage:[UIImage imageNamed:@"placehold_a.png"]];
    
    //Using UIImageView of SDWebImage => block UI
    //[cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:article.att3_thumbnailURL] placeholderImage:[UIImage imageNamed:@"placehold_a.png"] options:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [ArticlesModel shareArticlesModel].currentArticlesList.count - 1
        && indexPath.row == kPageSize * [ArticlesModel shareArticlesModel].currentPage - 1) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self performSelector:@selector(performLoadMoreArticles) withObject:nil afterDelay:0.1];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if ([self.delegate respondsToSelector:@selector(didSelectListArticles:atIndexPath:)]) {
        [self.delegate didSelectListArticles:self atIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
