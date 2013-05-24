//
//  ArticlesModel.m
//  True-X
//
//  Created by Dao Nguyen on 5/23/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ArticlesModel.h"
#import "TrueXAPIClient.h"

static ArticlesModel *_shareArticlesModel = nil;
@implementation ArticlesModel {
    
}

+ (ArticlesModel *)shareArticlesModel {
    if (!_shareArticlesModel) {
        _shareArticlesModel = [[ArticlesModel alloc] init];
    }
    return _shareArticlesModel;
}

- (void)getArticlesList {
    
}


@end
