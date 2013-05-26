//
//  ArticleDetailViewController.h
//  True-X
//
//  Created by Dao Nguyen on 5/12/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Articles.h"

@interface ArticleDetailViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *articleWebView;
@property (nonatomic, weak) Articles *article;

@end
