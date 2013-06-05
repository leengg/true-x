// UIImageView+AFNetworking.m
//
// Copyright (c) 2011 Gowalla (http://gowalla.com/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "UIImageView+AFNetworking.h"
//@Dao add AFNetworking memmory cache thumbnail only; add file cache
#import "UIImage+Scale.h"
#import "ImageCacheManager.h"
//@end Dao

@interface AFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image forRequest:(NSURLRequest *)request isThumbnailSize:(CGSize)size;
@end

#pragma mark -

static char kAFImageRequestOperationObjectKey;
static NSString  *isThumnailTag = @"2";

@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, retain, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;
//@Dao add AFNetworking memmory cache thumbnail only; add file cache
@property (nonatomic, readwrite, retain) NSString *isThumbnail;
//@end Dao
@end

@implementation UIImageView (_AFNetworking)
@dynamic af_imageRequestOperation, isThumbnail;
@end

#pragma mark -

@implementation UIImageView (AFNetworking)

//@Dao add
- (id)isThumbnail {
    return objc_getAssociatedObject(self, isThumnailTag);
}

- (void)setIsThumbnail:(NSString *)newIsThumbnail {
    objc_setAssociatedObject(self, isThumnailTag, newIsThumbnail, OBJC_ASSOCIATION_ASSIGN);
}
//@end Dao

- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(AFImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    
    if (!_af_imageRequestOperationQueue) {
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:8];
    }
    
    return _af_imageRequestOperationQueue;
}

+ (AFImageCache *)af_sharedImageCache {
    static AFImageCache *_af_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _af_imageCache = [[AFImageCache alloc] init];
    });
    
    return _af_imageCache;
}

#pragma mark -

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

//@Dao add AFNetworking memmory cache thumbnail only; add file cache
- (void)setThumbnailImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage {

    self.isThumbnail = isThumnailTag;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}
//@end Dao

- (void)setImageWithURL:(NSURL *)url 
       placeholderImage:(UIImage *)placeholderImage
{
    //@Dao add AFNetworking memmory cache thumbnail only; add file cache
    self.isThumbnail = nil;
    //@end Dao
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest 
              placeholderImage:(UIImage *)placeholderImage 
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];
    
    UIImage *cachedImage = nil;
  
    //@Dao add AFNetworking memmory cache thumbnail only; add file cache
    if (self.isThumbnail) {
        cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
        //query cached image file if no cached memory
        if (!cachedImage) {
            ImageCacheManager *myImageCacheManager = [ImageCacheManager sharedImageCacheManager];
            NSString *thumbImageKey = [NSString stringWithFormat:@"%@%@", [ImageCacheManager stringHash:[[urlRequest URL] absoluteString]], isThumnailTag];
            cachedImage = [myImageCacheManager imageForKey:thumbImageKey];
        }
    }
    else {
        //Dao add cached image by save file
        ImageCacheManager *myImageCacheManager = [ImageCacheManager sharedImageCacheManager];
        NSString *imageKey = [ImageCacheManager stringHash:[[urlRequest URL] absoluteString]];
        cachedImage = [myImageCacheManager imageForKey:imageKey];
        //@end Dao
    }
        
    if (cachedImage) {
        
        self.image = cachedImage;

        self.af_imageRequestOperation = nil;
        
        if (success) {
            success(nil, nil, cachedImage);
        }
    } else {
        self.image = placeholderImage;
        
        AFImageRequestOperation *requestOperation = [[[AFImageRequestOperation alloc] initWithRequest:urlRequest] autorelease];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                
                if (self.isThumbnail) {
                    //[NSThread detachNewThreadSelector:@selector(setImageInBackground:) toTarget:self withObject:responseObject];
                    self.image = [(UIImage *)responseObject imageByScalingAndCroppingForSize:self.frame.size withRate:2];
                }
                else {
                    self.image = responseObject;
                }
                self.af_imageRequestOperation = nil;
            }

            if (success) {
                success(operation.request, operation.response, responseObject);
            }
            //@Dao add AFNetworking memmory cache thumbnail only; add file cache
            //NSDictionary *imageDict = [[NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"image", urlRequest, @"request", nil] autorelease];
            //[NSThread detachNewThreadSelector:@selector(cacheImageInBackground:) toTarget:self withObject:imageDict];
            [[[self class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest isThumbnailSize:(self.isThumbnail ? self.frame.size : CGSizeZero)];
            //@end Dao
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                self.af_imageRequestOperation = nil;
            }

            if (failure) {
                failure(operation.request, operation.response, error);
            }
            
        }];
        
        self.af_imageRequestOperation = requestOperation;
        
        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

//@Dao add do cached image in background thread
- (void)cacheImageInBackground:(NSDictionary *)params {
    
    [[[self class] af_sharedImageCache] cacheImage:[params objectForKey:@"image"] forRequest:[params objectForKey:@"request"] isThumbnailSize:(self.isThumbnail ? self.frame.size : CGSizeZero)];
}

- (void)setImageInBackground:(UIImage *)image {
    self.image = [image imageByScalingAndCroppingForSize:self.frame.size withRate:2];
}
//@end Dao

@end

#pragma mark -

static inline NSString * AFImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@implementation AFImageCache

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    
	return [self objectForKey:AFImageCacheKeyFromURLRequest(request)];
}

- (void)cacheImage:(UIImage *)image forRequest:(NSURLRequest *)request isThumbnailSize:(CGSize)size
{
    if (image && request) {
        
        ImageCacheManager *myImageCacheManager = [ImageCacheManager sharedImageCacheManager];

        //Dao cache for thumbnail image only
        if (!CGSizeEqualToSize(size, CGSizeZero)) {
            UIImage *thumbnailImage = [image imageByScalingAndCroppingForSize:size withRate:2];
            [self setObject:thumbnailImage forKey:AFImageCacheKeyFromURLRequest(request)];
            
            NSString *thumbImageKey = [NSString stringWithFormat:@"%@%@", [ImageCacheManager stringHash:[[request URL] absoluteString]], isThumnailTag];
            [myImageCacheManager storeImage:thumbnailImage withKey:thumbImageKey];
        }

        //Dao add cached image by save file
        NSString *imageKey = [ImageCacheManager stringHash:[[request URL] absoluteString]];
        [myImageCacheManager storeImage:image withKey:imageKey];
        //@end Dao
    }
}

@end

#endif
