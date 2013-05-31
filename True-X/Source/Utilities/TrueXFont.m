//
//  TrueXFont.m
//  True-X
//
//  Created by InfoNam on 5/31/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "TrueXFont.h"

static UIFont *_pageNumberFont = nil;
static UIFont *_productNameFont = nil;
static UIFont *_feelingNameFont = nil;
static UIFont *_titleFont = nil;
static UIFont *_descriptionFont = nil;

@implementation TrueXFont

+ (UIFont *)pageNumberFont {
    
    if (!_pageNumberFont) {
        _pageNumberFont = [UIFont fontWithName:@"MyriadPro-Cond" size:18.0];
        
    }
    return _pageNumberFont;
}

+ (UIFont *)productNameFont {
    
    if (!_productNameFont) {
        _productNameFont = [UIFont fontWithName:@"MyriadPro-Cond" size:24.0];
        
    }
    return _productNameFont;
}

+ (UIFont *)feelingNameFont {
    
    if (!_feelingNameFont) {
        _feelingNameFont = [UIFont fontWithName:@"MyriadPro-It" size:16.0];
    }
    return _feelingNameFont;

}

+ (UIFont *)titleFont {

    if (!_titleFont) {
        _titleFont = [UIFont fontWithName:@"MyriadPro-Bold" size:19.0];
    }
    return _titleFont;

}

+ (UIFont *)descriptionFont {

    if (!_descriptionFont) {
        _descriptionFont = [UIFont fontWithName:@"MyriadPro-Cond" size:17.0];
    }
    return _descriptionFont;

}

@end
