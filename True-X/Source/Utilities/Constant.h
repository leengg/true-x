//
//  Constant.h
//  True-X
//
//  Created by Dao Nguyen on 5/21/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#ifndef True_X_Constant_h
#define True_X_Constant_h

#define kTrueXBaseURL               @"http://true-x.net/service/"
#define kArticleAPIName             @"articles/getArticlesForCategory.php"
#define kProductAPIName             @"products/getProducts.php"

#define kCategoryID                 @"categoryID"
#define kFromDate                   @"fromDate"
#define kNumberOfArticles           @"numberOfArticles"
#define kPageSize       30

#define NOTIFICATION_ARTICLE_DID_FINISH_LOAD    @"1"

typedef enum {
    FirstPage = 1,
    SecondPage =2,
    ThirdPage = 3,
    FourthPage = 4
}PageOrder;

typedef enum {
    NextPage = 1,
    PreviewPage =2
}PagingDirection;

typedef enum {
    PhongDoID = 6,
    DangCapID = 8,
    ChuyenBenLeID = 9,
    TuVanID= 0
}CategoryID;


#endif
