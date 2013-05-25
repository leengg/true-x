//
//  ListArticlesViewController.h
//  True-X
//
//  Created by Dao Nguyen on 5/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticlesModel.h"

@class ListArticlesViewController;

@protocol ListArticlesSelectedDelegate <NSObject>

@required
- (void)didSelectListArticles:(ListArticlesViewController *)listArticlesVC atIndexPath:(NSIndexPath *)index;
- (void)didScrollToBottom:(ListArticlesViewController *)listArticlesVC atIndexPage:(int)index;

@end

@interface ListArticlesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listArticlesTableView;
@property (nonatomic, weak) id<ListArticlesSelectedDelegate> delegate;

@end
