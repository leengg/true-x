//
//  TrueXLoading.m
//  True-X
//
//  Created by Dao Nguyen on 5/25/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "TrueXLoading.h"

static TrueXLoading *_shareLoading = nil;

@implementation TrueXLoading

+ (id)shareLoading
{
    if (!_shareLoading) {
        // Initialization code
        UIWindow *mainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        _shareLoading = [[TrueXLoading alloc] initWithWindow:mainWindow];
        _shareLoading.dimBackground = YES;
        [mainWindow addSubview:_shareLoading];
    }
    return _shareLoading;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
