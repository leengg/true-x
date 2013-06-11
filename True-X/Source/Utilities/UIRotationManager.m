//
//  UIRotationManager.m
//  True-X
//
//  Created by InfoNam on 6/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "UIRotationManager.h"

@implementation UIRotationManager

static UIRotationManager *sharedInstance;
+ (void)initialize
{
    sharedInstance = [[UIRotationManager alloc] init];
}
+ (UIRotationManager *)sharedInstance
{
    return sharedInstance;
}
- (id)init
{
    self = [super init];
    return self;
}
// iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    }
}
// iOS 6
- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}
// iOS6
- (BOOL) shouldAutorotate
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

@end
