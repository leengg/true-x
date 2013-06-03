//
//  ImageCacheManager.m
//  True-X
//
//  Created by InfoNam on 6/3/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "ImageCacheManager.h"

static ImageCacheManager *cacheManager = nil;

@interface ImageCacheManager (Private)

- (NSString *)getCacheDirectoryName;
- (BOOL)imageExistsInDisk:(NSString *)key;
- (NSString *)getFileNameForKey:(NSString *)key;

@end

@implementation ImageCacheManager

@synthesize imageLifeTime;

+ (id)sharedImageCacheManager { //used//
    
	@synchronized(self) {
		// If the class variable holding the reference to the single DataLink object is empty create it.
		if(cacheManager == nil) {
			cacheManager = [[self alloc] init];
		}
	}
	return cacheManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        imageLifeTime = IMAGE_FILE_LIFETIME;
        
        NSString *cacheDirectoryName = [self getCacheDirectoryName];
        BOOL isDirectory = NO;
        BOOL folderExists = [fileManager fileExistsAtPath:cacheDirectoryName isDirectory:&isDirectory] && isDirectory;
		
        if (!folderExists)
        {
            [fileManager createDirectoryAtPath:cacheDirectoryName withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
    return self;
}

- (void)dealloc
{
    fileManager = nil;
}

#pragma mark -
#pragma mark Public methods

- (UIImage *)imageForKey:(NSString *)key //used//
{
    if ([self imageExistsInDisk:key])
    {
        UIImage *image;
        NSData *data;
        NSString *fileName = [self getFileNameForKey:key];
        if ([fileName length] >0) {
            data = [[NSData alloc ] initWithContentsOfFile:fileName];
            image = [UIImage imageWithData:data];
        }
        return [UIImage imageWithCGImage:image.CGImage];
    }
    return nil;
}

- (void)storeImage:(UIImage *)image withKey:(NSString *)key ////// BUTTA /////
{
    if (image != nil && key != nil)
    {
        NSString *fileName = [self getFileNameForKey:key];
        [UIImagePNGRepresentation(image) writeToFile:fileName atomically:YES];
    }
}

+ (void)cleanUp {
    
    if ([[ImageCacheManager sharedImageCacheManager] countImagesInDisk] > IMAGE_FILE_LIMIT_COUNT) {
        [[ImageCacheManager sharedImageCacheManager] removeOldImages];
    }
}


#pragma mark - Other methods

- (void)removeImageWithKey:(NSString *)key
{	
    if ([self imageExistsInDisk:key])
    {
        NSError *error = nil;
        NSString *fileName = [self getFileNameForKey:key];
        [fileManager removeItemAtPath:fileName error:&error];
    }
}

- (void)removeAllImages
{
    NSError *error = nil;
    NSString *cacheDirectoryName = [self getCacheDirectoryName];
    NSArray *items = [fileManager  contentsOfDirectoryAtPath:cacheDirectoryName error:&error];
    for (NSString *item in items)
    {
        NSString *path = [cacheDirectoryName stringByAppendingPathComponent:item];
        [fileManager removeItemAtPath:path error:&error];
    }
}

- (void)removeOldImages
{
    NSString *cacheDirectoryName = [self getCacheDirectoryName];
    NSError *error = nil;
    NSArray *items = [fileManager contentsOfDirectoryAtPath:cacheDirectoryName error:&error];
    
    for (NSString *item in items)
    {
        NSString *path = [cacheDirectoryName stringByAppendingPathComponent:item];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:nil];
        /* FRANCO 2 */
        NSDate *creationDate = [attributes valueForKey:NSFileModificationDate];
        /* FRANCO 2 */
        //        NSTimeInterval;
        if (abs([creationDate timeIntervalSinceNow]) > imageLifeTime)
        {
            [fileManager removeItemAtPath:path error:&error];
        }
    }
}

- (void)removeOldImageWithKey:(NSString *)key //used//
{
    NSString *path = [self getFileNameForKey:key];
    if (![fileManager fileExistsAtPath:path]) {
        return;
    }
    
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:nil];
    
    NSDate *creationDate = [attributes valueForKey:NSFileModificationDate];
    
    if (abs([creationDate timeIntervalSinceNow]) > imageLifeTime)
    {
        [self removeImageWithKey:key];
    }
}

- (BOOL)isOldImageWithKey:(NSString *)key{
    
    NSString *path = [self getFileNameForKey:key];
    if (![fileManager fileExistsAtPath:path]) {
        return YES;
    }
    
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:nil];
    
    NSDate *creationDate = [attributes valueForKey:NSFileModificationDate];
    
    if (abs([creationDate timeIntervalSinceNow]) > imageLifeTime)
    {
        return YES;
    }
    return NO;
}

- (NSUInteger)countImagesInDisk
{
    NSString *cacheDirectoryName = [self getCacheDirectoryName];
    NSError *error;
    NSArray *items = [fileManager contentsOfDirectoryAtPath:cacheDirectoryName error:&error];
    return [items count];
}

#pragma mark -
#pragma mark Private methods

- (NSString *)getCacheDirectoryName //used//
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:IMAGE_CACHE_FOLDER_NAME];
    return cacheDirectoryName;
}

- (BOOL)imageExistsInDisk:(NSString *)key //used//
{
    NSString *fileName = [self getFileNameForKey:key];
    return [fileManager fileExistsAtPath:fileName];
}

- (NSString *)getFileNameForKey:(NSString *)key //used//
{
    NSString *cacheDirectoryName = [self getCacheDirectoryName];
    NSString *fileName = [cacheDirectoryName stringByAppendingPathComponent:key];
    return fileName;
}

+ (NSString*)stringHash:(NSString*)aStringToHash { //used//
    
    NSUInteger imageKeyNumber = [aStringToHash hash];
    NSString *imageKey = [NSString stringWithFormat:@"%d", imageKeyNumber];
    return imageKey;
}

@end
