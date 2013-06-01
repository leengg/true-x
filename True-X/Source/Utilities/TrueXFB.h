//
//  TrueXFB.h
//  True-X
//
//  Created by Dao Nguyen on 6/1/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface TrueXFB : NSObject

+ (TrueXFB *)shareTrueXFB;
+ (void)trueXFBWillTerminate;
+ (void)trueXFBDidBecomeActive;
+ (BOOL)trueXFB:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)shareFB:(NSDictionary *)params onViewController:(UIViewController *)viewController;

@end
