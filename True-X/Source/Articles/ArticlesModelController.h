//
//  ArticlesModelController.h
//  True-X
//
//  Created by Dao Nguyen on 5/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Articles.h"
#import "ArticlesCategories.h"

@interface ArticlesModelController : NSObject

- (NSArray *)getArticlesForCategory:(NSString *)categoryID fromDate:(NSDate *)date withLimit:(int )numberOfArticles;
- (NSArray *)getAllArticlesCategories;

- (void)updateArticles:(NSArray *)articles;
- (void)updateArticlesCategories:(NSArray *)categories;

- (void)deleteArticles:(NSArray *)articles;
- (void)deleteArticlesCategories:(NSArray *)categories;

- (void)insertArticles:(NSArray *)articles;
- (void)insertArticlesCategories:(NSArray *)categories;

@end
