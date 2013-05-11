//
//  ArticlesCategories.h
//  True-X
//
//  Created by Dao Nguyen on 5/10/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Articles;

@interface ArticlesCategories : NSManagedObject

@property (nonatomic, retain) NSString * att1_id;
@property (nonatomic, retain) NSString * att2_name;
@property (nonatomic, retain) NSString * att3_descriptionText;
@property (nonatomic, retain) NSString * att4_iconURL;
@property (nonatomic, retain) NSDate * att5_createdDate;
@property (nonatomic, retain) NSDate * att6_updatedDate;
@property (nonatomic, retain) NSSet *articles;
@end

@interface ArticlesCategories (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(Articles *)value;
- (void)removeArticlesObject:(Articles *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
