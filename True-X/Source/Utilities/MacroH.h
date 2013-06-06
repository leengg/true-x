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

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)
#define IOS_APP_NAME (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]

#endif
