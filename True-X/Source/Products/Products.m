//
//  Products.m
//  True-X
//
//  Created by Dao Nguyen on 5/26/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "Products.h"
#import "ProductSlides.h"


@implementation Products

@dynamic att1_id;
@dynamic att2_name;
@dynamic att3_categoryName;
@dynamic att4_description;
@dynamic att5_thumbnailURL;
@dynamic att6_createdDate;
@dynamic att7_updatedDate;
@dynamic slide;

- (Products *)setAttributes:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)currentContext {
    
    if (self) {
        
        self.att1_id = [[attributes valueForKeyPath:@"id"] integerValue];
        self.att2_name = [attributes valueForKeyPath:@"name"];
        self.att3_categoryName = [attributes valueForKeyPath:@"categoryName"];
        self.att4_description = [attributes valueForKeyPath:@"description"];
        self.att5_thumbnailURL = [attributes valueForKeyPath:@"thumbnailURL"];
        //        self.att6_createdDate = [attributes valueForKeyPath:@"createdDate"];
        //        self.att7_updatedDate = [attributes valueForKeyPath:@"updatedDate"];
        
        id childJSON = [attributes valueForKeyPath:@"productSlides"];
        for (NSDictionary *child in childJSON) {
  
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"att1_id == %d AND att5_productID == %d", [[child valueForKeyPath:@"id"] intValue], self.att1_id];
            ProductSlides *productSlide = [ProductSlides findFirstWithPredicate:predicate];
            if (!productSlide) {
                productSlide = [ProductSlides createInContext:currentContext];
                productSlide.product = self;
            }
            [productSlide setAttributes:child];
            productSlide.att5_productID = [NSString stringWithFormat:@"%d", self.att1_id];
            [self removeSlideObject:productSlide];
            [self addSlideObject:productSlide];
        }
    }
    return self;
}

@end
