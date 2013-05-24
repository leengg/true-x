//
//  ArticlesModel.h
//  True-X
//
//  Created by Dao Nguyen on 5/23/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticlesModel : NSObject

@property (nonatomic, strong) NSString *currentCatoryID;
@property (nonatomic) int currentPage;
@property (nonatomic, strong) NSMutableArray *currentArticlesList;

+ (ArticlesModel *)shareArticlesModel;
- (void)getArticlesList;

@end
