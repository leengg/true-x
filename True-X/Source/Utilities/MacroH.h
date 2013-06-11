//
//  MacroH.h
//  True-X
//
//  Created by InfoNam on 5/15/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "Constant.h"
#import "TrueXLoading.h"
#import "TrueXFont.h"
#import "TrueXAlert.h"
#import "TrueXFB.h"
#import "ImageCacheManager.h"

#ifndef True_X_MacroH_h
#define True_X_MacroH_h

/*
 *  System Device Detection Macros
 */
#define IS_IPHONE_5             (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPAD                     ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)

/*
 *  Application Name Macros
 */
#define IOS_APP_NAME            (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                                          ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)                                      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                                         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*
 *  Usage example
 *
 *  if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
 *  ...
 *  }
 *
 *  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
 *  ...
 *  }
 *
 */

#endif
