//
//  ProductsModel.h
//  True-X
//
//  Created by Dao Nguyen on 5/26/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrueXAPIClient.h"
#import "Products.h"

@interface ProductsModel : NSObject

@property (nonatomic) int currentPage;
@property (nonatomic, strong) NSMutableArray *currentProductsList;

+ (ProductsModel *)shareProductsModel;
- (void)getProductsList:(BOOL)isRefesh;

@end
