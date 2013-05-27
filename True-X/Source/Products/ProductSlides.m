//
//  ProductSlides.m
//  True-X
//
//  Created by Dao Nguyen on 5/27/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ProductSlides.h"
#import "Products.h"


@implementation ProductSlides

@dynamic att1_id;
@dynamic att2_name;
@dynamic att3_description;
@dynamic att4_thumbnailURL;
@dynamic att5_productID;
@dynamic product;

- (ProductSlides *)setAttributes:(NSDictionary *)attributes {
    
    if (self) {
        
        self.att1_id = [attributes valueForKeyPath:@"id"];
        self.att2_name = [attributes valueForKeyPath:@"title"];
        self.att3_description = [attributes valueForKeyPath:@"description"];
        self.att4_thumbnailURL = [attributes valueForKeyPath:@"thumbnailURL"];
    }
    return self;
}

@end
