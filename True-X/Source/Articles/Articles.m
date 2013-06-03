//
//  Articles.m
//  True-X
//
//  Created by Dao Nguyen on 6/3/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "Articles.h"


@implementation Articles

@dynamic att1_id;
@dynamic att2_title;
@dynamic att3_thumbnailURL;
@dynamic att4_descriptionText;
@dynamic att5_contentHTML;
@dynamic att6_author;
@dynamic att7_categoryID;
@dynamic att8_createdDate;
@dynamic att9_updatedDate;

- (Articles *)setAttributes:(NSDictionary *)attributes {
    
    if (self) {
        
        self.att1_id = [NSNumber numberWithInteger:[[attributes valueForKeyPath:@"id"] integerValue]];
        self.att2_title = [attributes valueForKeyPath:@"title"];
        self.att3_thumbnailURL = [attributes valueForKeyPath:@"thumbnailURL"];
        self.att4_descriptionText = [attributes valueForKeyPath:@"description"];
        self.att5_contentHTML = [attributes valueForKeyPath:@"contentHTML"];
        self.att6_author = [attributes valueForKeyPath:@"author"];
        self.att7_categoryID = [attributes valueForKeyPath:@"categoryID"];
        //self.att8_createdDate = [attributes valueForKeyPath:@"createdDate"];
        //self.att9_updatedDate = [attributes valueForKeyPath:@"ngay_cap_nhat"];
    }
    return self;
}

@end
