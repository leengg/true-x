//
//  UIRotationManager.h
//  True-X
//
//  Created by InfoNam on 6/11/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIRotationManager : NSObject

+ (UIRotationManager*) sharedInstance;
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation;
- (NSUInteger)supportedInterfaceOrientations;
- (BOOL) shouldAutorotate;

@end
