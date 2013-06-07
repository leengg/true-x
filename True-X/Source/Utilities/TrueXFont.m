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
        if (IS_IPAD) {
            _pageNumberFont = [UIFont fontWithName:@"MyriadPro-Cond" size:28.0];
        }
        else {
            _pageNumberFont = [UIFont fontWithName:@"MyriadPro-Cond" size:18.0];
        }
    }
    return _pageNumberFont;
}

+ (UIFont *)productNameFont {
    
    if (!_productNameFont) {
        if (IS_IPAD) {
        _productNameFont = [UIFont fontWithName:@"MyriadPro-Cond" size:36.0];
        }
        else {
        _productNameFont = [UIFont fontWithName:@"MyriadPro-Cond" size:24.0];
        }
    }
    return _productNameFont;
}

+ (UIFont *)feelingNameFont {
    
    if (!_feelingNameFont) {
        if (IS_IPAD) {
            _feelingNameFont = [UIFont fontWithName:@"MyriadPro-It" size:22.0];
        }
        else {
        _feelingNameFont = [UIFont fontWithName:@"MyriadPro-It" size:16.0];            
        }
    }
    return _feelingNameFont;

}

+ (UIFont *)titleFont {

    if (!_titleFont) {
        if (IS_IPAD) {
            _titleFont = [UIFont fontWithName:@"MyriadPro-Bold" size:26.0];
        }
        else {
            _titleFont = [UIFont fontWithName:@"MyriadPro-Bold" size:17.0];
        }
    }
    return _titleFont;

}

+ (UIFont *)descriptionFont {

    if (!_descriptionFont) {
        if (IS_IPAD) {
            _descriptionFont = [UIFont fontWithName:@"MyriadPro-Cond" size:22.0];
        }
        else {
            _descriptionFont = [UIFont fontWithName:@"MyriadPro-Cond" size:18.0];            
        }
    }
    return _descriptionFont;

}

@end
