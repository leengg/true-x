//
//  UIImage+Scale.h
//  True-X
//
//  Created by Dao Nguyen on 6/2/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage *)scaleImage:(UIImage*)image toResolution:(int)resolution;
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withRate:(int)rate;
- (UIImage*)scaleAndCropToSize:(CGSize)newSize;

@end
