//
//  ArticlesModel.m
//  True-X
//
//  Created by Dao Nguyen on 5/23/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ArticlesModel.h"

static ArticlesModel *_shareArticlesModel = nil;
@implementation ArticlesModel {
    
}

+ (ArticlesModel *)shareArticlesModel {
    if (!_shareArticlesModel) {
        _shareArticlesModel = [[ArticlesModel alloc] init];
    }
    return _shareArticlesModel;
}

-(void)sendNotificationDidFinishLoadArticles:(BOOL)loadMoreFlag
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ARTICLE_DID_FINISH_LOAD object:[[NSNumber alloc] initWithBool:loadMoreFlag]];
}

- (void)getArticlesList {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"att7_categoryID == %d", self.currentCatoryID];
    self.currentArticlesList = [[NSMutableArray alloc] initWithArray:[Articles findAllWithPredicate:predicate]];
    self.currentPage = (self.currentArticlesList.count / kPageSize) < self.currentPage ? self.currentPage : self.currentArticlesList.count / kPageSize;
        
    [self sendNotificationDidFinishLoadArticles:NO];

    NSString *categoryIDString = [NSString stringWithFormat:@"%d", self.currentCatoryID];
    NSString *numberOfArticles = [NSString stringWithFormat:@"%d", self.currentPage * kPageSize];
    
    NSDictionary *paras = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:categoryIDString, numberOfArticles, nil] forKeys:[NSArray arrayWithObjects:kCategoryID, kNumberOfArticles, nil]];
    
    //@show loading
    if (self.currentArticlesList.count) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    else {
        [[TrueXLoading shareLoading] show:YES];
    }
    
    [[TrueXAPIClient sharedAPIClient] getPath:kArticleAPIName parameters:paras
                                      success:^(AFHTTPRequestOperation *operation, id JSON)
                                      {                                          
                                          [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
                                          {
                                              for (NSDictionary *attributes in JSON) {

                                                  NSString *articleID = [attributes valueForKeyPath:@"id"];
                                                  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"att1_id == %@", articleID];
                                                  Articles *article = [Articles findFirstWithPredicate:predicate];
                                                  if (!article) {
                                                      article = [Articles createInContext:localContext];
                                                  }
                                                  [article setAttributes:attributes];
                                              }
                                          } completion:^(BOOL success, NSError *error)
                                          {
                                              //@hide loading
                                              [[TrueXLoading shareLoading] hide:YES];
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                                              if (success) {
                                                  self.currentArticlesList = [[NSMutableArray alloc] initWithArray:[Articles findAllWithPredicate:predicate]];
                                              }
                                              else {
                                                  NSLog(@"MagicalRecord Error: %@", error);
                                              }
                                              [self sendNotificationDidFinishLoadArticles:YES];
                                          }];
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                      {
                                          //@hide loading
                                          [[TrueXLoading shareLoading] hide:YES];
                                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          NSLog(@"AFNetworking Error: %@", error);
                                      }];
    
}


@end
