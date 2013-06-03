//
//  ImageCacheManager.h
//  True-X
//
//  Created by InfoNam on 6/3/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

// cache folder in documents app folder:
#define IMAGE_CACHE_FOLDER_NAME @"ImageCache"

// 1 hours in seconds = 60 * 60 = 3600  // in seconds
#define IMAGE_FILE_LIFETIME 3600.0

@interface ImageCacheManager : NSObject {
    
@private
    NSMutableArray *keyArray;
    NSFileManager *fileManager;
    int imageLifeTime;
}

@property(nonatomic)int imageLifeTime;


+(NSString*)stringHash:(NSString*)aStringToHash;

+ (id)getSharedImageCacheManager;

- (UIImage *)imageForKey:(NSString *)key;

- (BOOL)hasImageWithKey:(NSString *)key;

- (void)storeData:(NSData *)myData withKey:(NSString *)key;

- (void)storeImage:(UIImage *)image withKey:(NSString *)key;

//- (BOOL)imageExistsInMemory:(NSString *)key;

- (BOOL)imageExistsInDisk:(NSString *)key;

//- (NSUInteger)countImagesInMemory;

- (NSUInteger)countImagesInDisk;

- (void)removeImageWithKey:(NSString *)key;

- (void)receiveMemoryWarning;

- (void)removeAllImages;

//- (void)removeAllImagesInMemory;

- (void)removeOldImages;

- (void)removeOldImageWithKey:(NSString *)key;

- (BOOL)isOldImageWithKey:(NSString *)key;

@end
