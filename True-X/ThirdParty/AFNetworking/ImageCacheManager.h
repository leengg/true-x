//
//  ImageCacheManager.h
//  True-X
//
//  Created by InfoNam on 6/3/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

// Cache folder in documents app folder:
#define IMAGE_CACHE_FOLDER_NAME @"ImageCache"

// 7 days in seconds = 7 * 24 * 60 * 60 = 604800  // in seconds
#define IMAGE_FILE_LIFETIME 604800.0
#define IMAGE_FILE_LIMIT_COUNT 1000

@interface ImageCacheManager : NSObject {
    
@private
    NSFileManager *fileManager;
    int imageLifeTime;
}

@property(nonatomic) int imageLifeTime;

// main public methods

+ (NSString*)stringHash:(NSString*)aStringToHash;

+ (id)sharedImageCacheManager;

+ (void)cleanUp;

- (UIImage *)imageForKey:(NSString *)key;

- (void)storeImage:(UIImage *)image withKey:(NSString *)key;

// other public methods

- (NSUInteger)countImagesInDisk;

- (void)removeImageWithKey:(NSString *)key;

- (void)removeAllImages;

- (void)removeOldImages;

- (void)removeOldImageWithKey:(NSString *)key;

- (BOOL)isOldImageWithKey:(NSString *)key;

@end
