//
//  TrueXAlert.m
//  True-X
//
//  Created by Dao Nguyen on 6/1/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "TrueXAlert.h"

static UIAlertView *_shareAlert = nil;

@implementation TrueXAlert

+ (UIAlertView *)shareAlert {
    
    if (!_shareAlert) {
        _shareAlert = [[UIAlertView alloc] initWithTitle:IOS_APP_NAME message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    return _shareAlert;
}

@end
