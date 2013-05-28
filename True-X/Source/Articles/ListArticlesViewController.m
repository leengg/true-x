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
    if( !IS_IPHONE_5 )
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 38, self.view.frame.size.width, 480-20 - 38);
    }
    else
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 38, self.view.frame.size.width, 568-20 - 38);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadListArticles:) name:NOTIFICATION_ARTICLE_DID_FINISH_LOAD object:nil];

}

- (void)reloadListArticles:(NSNotification *)notification {
    
    self.listArticlesTableView.hidden = ([ArticlesModel shareArticlesModel].currentArticlesList.count == 0) ? YES : NO;

    [self.listArticlesTableView reloadData];
    canLoadMore = [notification.object boolValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [[[ArticlesModel shareArticlesModel] currentArticlesList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleCellID";
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    Articles *article = (Articles *)[[[ArticlesModel shareArticlesModel] currentArticlesList] objectAtIndex:indexPath.row];

    cell.titleTextView.text = article.att2_title;
    [cell.thumbnailImageView setImageWithURL:[NSURL URLWithString:article.att3_thumbnailURL] placeholderImage:[UIImage imageNamed:@"placehold.png"]];
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_accessory_view.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_cell_selected.png"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [ArticlesModel shareArticlesModel].currentArticlesList.count  - 1
        && indexPath.row == kPageSize * [ArticlesModel shareArticlesModel].currentPage - 1) {
        
        if (canLoadMore) {
            canLoadMore = NO;
            int currentPage = [ArticlesModel shareArticlesModel].currentArticlesList.count / kPageSize;
            [self.delegate didScrollToBottom:self atIndexPage:currentPage];
        }
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
