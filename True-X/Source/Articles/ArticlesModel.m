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

- (void)getArticlesList:(BOOL)isRefesh {
    
    NSLog(@"getArticlesList at page: %d for categoryID: %d", self.currentPage, self.currentCatoryID);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"att7_categoryID == %d", self.currentCatoryID];
    NSFetchRequest *request = [Articles requestAllSortedBy:@"att1_id" ascending:NO withPredicate:predicate];
    
    if (!isRefesh) {
        [request setFetchLimit:self.currentPage*kPageSize];
        self.currentArticlesList = [[NSMutableArray alloc] initWithArray:[Articles executeFetchRequest:request]];        
        [self sendNotificationDidFinishLoadArticles:YES];
        if (self.currentArticlesList.count > (self.currentPage-1)*kPageSize) {
            return;
        }
    }

    NSString *categoryIDString = [NSString stringWithFormat:@"%d", self.currentCatoryID];
    NSString *numberOfArticles = [NSString stringWithFormat:@"%d", self.currentPage * kPageSize];
    
    NSDictionary *paras = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:categoryIDString, numberOfArticles, nil] forKeys:[NSArray arrayWithObjects:kCategoryID, kNumberOfArticles, nil]];
    
    //@show loading
    [[TrueXLoading shareLoading] show:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[TrueXAPIClient sharedAPIClient] getPath:kArticleAPIName parameters:paras
                                      success:^(AFHTTPRequestOperation *operation, id JSON)
                                      {                                          
                                          [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
                                          {
                                              for (NSDictionary *attributes in JSON) {

                                                  NSInteger articleID = [[attributes valueForKeyPath:@"id"] integerValue];
                                                  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"att1_id == %d", articleID];
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

                                              [request setFetchLimit:self.currentPage*kPageSize ];
                                              self.currentArticlesList = [[NSMutableArray alloc] initWithArray:[Articles executeFetchRequest:request]];
                                              [self sendNotificationDidFinishLoadArticles:YES];
                                          }];
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                      {
                                          //@hide loading
                                          [[TrueXLoading shareLoading] hide:YES];
                                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          [TrueXAlert shareAlert].message = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
                                          [[TrueXAlert shareAlert] show];
                                          [self sendNotificationDidFinishLoadArticles:YES];
                                          NSLog(@"AFNetworking Error: %@", error);
                                      }];
    
}


@end
