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

- (void)getArticlesList {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"att7_categoryID == %d", self.currentCatoryID];
    self.currentArticlesList = [[NSMutableArray alloc] initWithArray:[Articles findAllWithPredicate:predicate]];
    self.currentPage = (self.currentArticlesList.count / kPageSize) > self.currentPage ? self.currentPage : self.currentArticlesList.count / kPageSize;
        
    [self sendNotificationDidFinishLoadArticles:NO];

    NSString *categoryIDString = [NSString stringWithFormat:@"%d", self.currentCatoryID];
    NSString *numberOfArticles = [NSString stringWithFormat:@"%d", self.currentPage * kPageSize];
    
    NSDictionary *paras = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:categoryIDString, numberOfArticles, nil] forKeys:[NSArray arrayWithObjects:kCategoryID, kNumberOfArticles, nil]];
    
    //@show loading
    [[TrueXLoading shareLoading] show:YES];
    
    [[TrueXAPIClient sharedAPIClient] getPath:kArticleAPIName parameters:paras
                                      success:^(AFHTTPRequestOperation *operation, id JSON)
                                      {
                                          //@hide loading
                                          [[TrueXLoading shareLoading] hide:YES];
                                          
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
                                              if (success) {
                                                  self.currentArticlesList = [[NSMutableArray alloc] initWithArray:[Articles findAllWithPredicate:predicate]];
                                                  [self sendNotificationDidFinishLoadArticles:YES];
                                              }
                                              else {
                                                  NSLog(@"MagicalRecord Error: %@", error);
                                                  [self sendNotificationDidFinishLoadArticles:NO];
                                              }
                                          }];
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                      {
                                          //@hide loading
                                          [[TrueXLoading shareLoading] hide:YES];
                                          NSLog(@"AFNetworking Error: %@", error);
                                      }];
    
}

-(void)sendNotificationDidFinishLoadArticles:(BOOL)loadMoreFlag
{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ARTICLE_DID_FINISH_LOAD object:[[NSNumber alloc] initWithBool:loadMoreFlag]];
}



@end
