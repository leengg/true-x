//
//  ProductsModel.m
//  True-X
//
//  Created by Dao Nguyen on 5/26/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ProductsModel.h"

static ProductsModel *_shareProductsModel = nil;

@implementation ProductsModel

+ (ProductsModel *)shareProductsModel {
    
    if (!_shareProductsModel) {
        _shareProductsModel = [[ProductsModel alloc] init];
    }
    return _shareProductsModel;
}

-(void)sendNotificationDidFinishLoadProducts:(BOOL)loadMoreFlag
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PRODUCT_DID_FINISH_LOAD object:[[NSNumber alloc] initWithBool:loadMoreFlag]];
}

- (void)getProductsList:(BOOL)isRefesh {
    
    if (!isRefesh) {
        self.currentProductsList = [[NSMutableArray alloc] initWithArray:[Products findAllSortedBy:@"att1_id" ascending:YES]];
        self.currentPage = (self.currentProductsList.count / kPageSize) < self.currentPage ? self.currentPage : self.currentProductsList.count / kPageSize;
        
        [self sendNotificationDidFinishLoadProducts:YES];
        if (self.currentProductsList.count > (self.currentPage-1)*kPageSize) {
            return;
        }
    }
    
    NSString *numberOfProducts = [NSString stringWithFormat:@"%d", self.currentPage * kPageSize];

    NSDictionary *paras = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:numberOfProducts, nil] forKeys:[NSArray arrayWithObjects:kNumberOfArticles, nil]];
    
    //@show loading
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[TrueXLoading shareLoading] show:YES];
    
    [[TrueXAPIClient sharedAPIClient] getPath:kProductAPIName parameters:paras
                                      success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
          {
              for (NSDictionary *attributes in JSON) {
                  
                  NSInteger productID = [[attributes valueForKeyPath:@"id"] integerValue];
                  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"att1_id == %d", productID];
                  Products *product = [Products findFirstWithPredicate:predicate];
                  if (!product) {
                      product = [Products createInContext:localContext];
                  }
                  [product setAttributes:attributes];
              }
          } completion:^(BOOL success, NSError *error)
          {
              if (success) {
                  self.currentProductsList = [[NSMutableArray alloc] initWithArray:[Products findAllSortedBy:@"att1_id" ascending:YES]];
              }
              else {
                  NSLog(@"MagicalRecord Error: %@", error);
              }
              [self sendNotificationDidFinishLoadProducts:YES];
              //@hide loading
              [[TrueXLoading shareLoading] hide:YES];
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
          }];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //@hide loading
         [[TrueXLoading shareLoading] hide:YES];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [TrueXAlert shareAlert].message = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
         [[TrueXAlert shareAlert] show];
         [self sendNotificationDidFinishLoadProducts:YES];
         NSLog(@"AFNetworking Error: %@", error);
     }];

}

@end
