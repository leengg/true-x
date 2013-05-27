//
//  ProductSlides.h
//  True-X
//
//  Created by Dao Nguyen on 5/27/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Products;

@interface ProductSlides : NSManagedObject

@property (nonatomic, retain) NSString * att1_id;
@property (nonatomic, retain) NSString * att2_name;
@property (nonatomic, retain) NSString * att3_description;
@property (nonatomic, retain) NSString * att4_thumbnailURL;
@property (nonatomic, retain) NSString * att5_productID;
@property (nonatomic, retain) Products *product;

- (ProductSlides *)setAttributes:(NSDictionary *)attributes;

@end
