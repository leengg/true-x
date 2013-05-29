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

- (void)getProductsList {
    
    self.currentProductsList = [[NSMutableArray alloc] initWithArray:[Products findAll]];
    self.currentPage = (self.currentProductsList.count / kPageSize) < self.currentPage ? self.currentPage : self.currentProductsList.count / kPageSize;
    
    [self sendNotificationDidFinishLoadProducts:NO];
    
    NSString *numberOfProducts = [NSString stringWithFormat:@"%d", self.currentPage * kPageSize];

    NSDictionary *paras = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:numberOfProducts, nil] forKeys:[NSArray arrayWithObjects:kNumberOfArticles, nil]];
    
    //@show loading
    if (self.currentProductsList.count) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    else {
        [[TrueXLoading shareLoading] show:YES];
    }
    
    [[TrueXAPIClient sharedAPIClient] getPath:kProductAPIName parameters:paras
                                      success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
          {
              for (NSDictionary *attributes in JSON) {
                  
                  NSString *productID = [attributes valueForKeyPath:@"id"];
                  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"att1_id == %@", productID];
                  Products *product = [Products findFirstWithPredicate:predicate];
                  if (!product) {
                      product = [Products createInContext:localContext];
                  }
                  [product setAttributes:attributes inContext:localContext];
              }
          } completion:^(BOOL success, NSError *error)
          {
              //@hide loading
              [[TrueXLoading shareLoading] hide:YES];
              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

              if (success) {
                  self.currentProductsList = [[NSMutableArray alloc] initWithArray:[Products findAll]];
              }
              else {
                  NSLog(@"MagicalRecord Error: %@", error);
              }
              [self sendNotificationDidFinishLoadProducts:YES];
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
