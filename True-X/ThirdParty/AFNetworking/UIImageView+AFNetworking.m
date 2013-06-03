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
//@Dao add AFNetworking cache thumbnail
#import "UIImage+Scale.h"
#import "ImageCacheManager.h"
//@end Dao

@interface AFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

#pragma mark -

static char kAFImageRequestOperationObjectKey;
static NSString  *isThumnailTag = @"2";

@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, retain, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;
//@Dao add AFNetworking cache thumbnail
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

//@Dao add AFNetworking cache thumbnail
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
    //@Dao add AFNetworking cache thumbnail
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
    
    UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    
    //@Dao add AFNetworking cache thumbnail
    if (cachedImage) {
        
        if (cachedImage.size.width < 2*self.frame.size.width && cachedImage.size.height < 2*self.frame.size.height) {
            cachedImage = nil;
        }
        else if (cachedImage.size.width > 2*self.frame.size.width || cachedImage.size.height > 2*self.frame.size.height) {
            cachedImage = [cachedImage imageByScalingAndCroppingForSize:self.frame.size withRate:[self.isThumbnail intValue]];
            [[[self class] af_sharedImageCache] cacheImage:cachedImage forRequest:urlRequest];
        }
        else {
            
        }
    }
    else {
        //Dao add cached image by save file
        ImageCacheManager *myImageCacheManager = [ImageCacheManager getSharedImageCacheManager];
        NSString *imageKey = [ImageCacheManager stringHash:[[urlRequest URL] absoluteString]];
        cachedImage = [myImageCacheManager imageForKey:imageKey];
        //@end Dao
    }
    //@end Dao
    
    if (cachedImage) {
        
        NSLog(@"is Cached before");
        self.image = cachedImage;
        NSLog(@"is Cached after");

        self.af_imageRequestOperation = nil;
        
        if (success) {
            success(nil, nil, cachedImage);
        }
    } else {
        self.image = placeholderImage;
        
        AFImageRequestOperation *requestOperation = [[[AFImageRequestOperation alloc] initWithRequest:urlRequest] autorelease];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //@Dao add AFNetworking cache thumbnail
            UIImage *thumbImage = (UIImage *)responseObject;
            if ([self.isThumbnail isEqualToString:isThumnailTag]) {
               thumbImage = [thumbImage imageByScalingAndCroppingForSize:self.frame.size withRate:[self.isThumbnail intValue]];
            }
            //@end Dao
            if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                self.image = thumbImage;
                self.af_imageRequestOperation = nil;
            }

            if (success) {
                success(operation.request, operation.response, responseObject);
            }

            [[[self class] af_sharedImageCache] cacheImage:thumbImage forRequest:urlRequest];
            
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

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        [self setObject:image forKey:AFImageCacheKeyFromURLRequest(request)];

        //Dao add cached image by save file
        ImageCacheManager *myImageCacheManager = [ImageCacheManager getSharedImageCacheManager];
        NSString *imageKey = [ImageCacheManager stringHash:[[request URL] absoluteString]];
        [myImageCacheManager storeImage:image withKey:imageKey];
        //@end Dao
    }
}

@end

#endif
