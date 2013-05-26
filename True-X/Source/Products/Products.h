//
//  Products.h
//  True-X
//
//  Created by Dao Nguyen on 5/26/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProductSlides;

@interface Products : NSManagedObject

@property (nonatomic, retain) NSString * att1_id;
@property (nonatomic, retain) NSString * att2_name;
@property (nonatomic, retain) NSString * att3_categoryName;
@property (nonatomic, retain) NSString * att4_description;
@property (nonatomic, retain) NSString * att5_thumbnailURL;
@property (nonatomic) NSTimeInterval att6_createdDate;
@property (nonatomic) NSTimeInterval att7_updatedDate;
@property (nonatomic, retain) NSSet *slide;
@end

@interface Products (CoreDataGeneratedAccessors)

- (void)addSlideObject:(ProductSlides *)value;
- (void)removeSlideObject:(ProductSlides *)value;
- (void)addSlide:(NSSet *)values;
- (void)removeSlide:(NSSet *)values;

@end
