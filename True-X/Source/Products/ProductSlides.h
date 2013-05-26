//
//  ProductSlides.h
//  True-X
//
//  Created by Dao Nguyen on 5/26/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductSlides : NSManagedObject

@property (nonatomic, retain) NSString * att1_id;
@property (nonatomic, retain) NSString * att2_name;
@property (nonatomic, retain) NSString * att3_description;
@property (nonatomic, retain) NSString * att4_thumbnailURL;
@property (nonatomic, retain) NSManagedObject *product;

@end
