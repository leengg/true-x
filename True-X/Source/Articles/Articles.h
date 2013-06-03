//
//  Articles.h
//  True-X
//
//  Created by InfoNam on 6/3/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Articles : NSManagedObject

@property (nonatomic) int16_t att1_id;
@property (nonatomic, retain) NSString * att2_title;
@property (nonatomic, retain) NSString * att3_thumbnailURL;
@property (nonatomic, retain) NSString * att4_descriptionText;
@property (nonatomic, retain) NSString * att5_contentHTML;
@property (nonatomic, retain) NSString * att6_author;
@property (nonatomic, retain) NSString * att7_categoryID;
@property (nonatomic) NSTimeInterval att8_createdDate;
@property (nonatomic) NSTimeInterval att9_updatedDate;

- (Articles *)setAttributes:(NSDictionary *)attributes;

@end
