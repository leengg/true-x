//
//  HomeProductsViewController.m
//  True-X
//
//  Created by Dao Nguyen on 5/12/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "HomeProductsViewController.h"
#import "ProductDetailViewController.h"
#import "ProductCell.h"
#import "UIRotationManager.h"

@interface HomeProductsViewController () {

    BOOL canLoadMore;
}

@end

@implementation HomeProductsViewController

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadListProducts:) name:NOTIFICATION_PRODUCT_DID_FINISH_LOAD object:nil];
    [[ProductsModel shareProductsModel] setCurrentPage:1];
    [[ProductsModel shareProductsModel] getProductsList:NO];
}

- (void)viewDidUnload {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)clickReload:(id)sender {
    
    [[ProductsModel shareProductsModel] getProductsList:YES];
}

- (void)reloadListProducts:(NSNotification *)notification {
    
    self.productsTableView.hidden = ([ProductsModel shareProductsModel].currentProductsList.count == 0) ? YES : NO;
    [self.productsTableView reloadData];
    canLoadMore = [notification.object boolValue];
}

- (void)performLoadMoreProducts {
    
    if (canLoadMore) {
        canLoadMore = NO;
        int currentPage = [ProductsModel shareProductsModel].currentProductsList.count / kPageSize;
        [[ProductsModel shareProductsModel] setCurrentPage:currentPage+1];
        [[ProductsModel shareProductsModel] getProductsList:YES];
    }
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
    return [ProductsModel shareProductsModel].currentProductsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCellID";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Products *product = [[ProductsModel shareProductsModel].currentProductsList objectAtIndex:indexPath.row];
    // Configure the cell...
    [cell.thumbnailImageView setThumbnailImageWithURL:[NSURL URLWithString:product.att5_thumbnailURL] placeholderImage:[UIImage imageNamed:@"placehold_s.png"]];
    cell.titleLabel.text = product.att2_name;   //@"Ultrathin";
    cell.descriptionLabel.text = product.att4_description;  //@"Cảm giác thật";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [ProductsModel shareProductsModel].currentProductsList.count  - 1
        && indexPath.row == kPageSize * [ProductsModel shareProductsModel].currentPage - 1) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self performSelector:@selector(performLoadMoreProducts) withObject:nil afterDelay:0.1];
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
    UIStoryboard *storyboard = nil;
    if (IS_IPAD) {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard-iPad" bundle:nil];
    }
    else {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard-iPhone" bundle:nil];
    }
    ProductDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProductDetailViewControllerID"];
    detailViewController.product = [[ProductsModel shareProductsModel].currentProductsList objectAtIndex:indexPath.row];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
