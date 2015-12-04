//
//  UIImage+LSPS.m
//  LSUIKit
//
//  Created by liulihui on 15/6/4.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "UIImage+LSPS.h"

@implementation UIImage (LSPS)

#pragma mark - Create
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createMaskWithImage:(UIImage *)image outColor:(UIColor *)outColor innerColor:(UIColor *)innerColor
{
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(image.CGImage), kCGBitmapAlphaInfoMask);
    
    CGContextSetFillColorWithColor(context, outColor.CGColor);
    CGContextFillRect(context, imageRect);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, image.CGImage);
    
    CGContextSetFillColorWithColor(context, innerColor.CGColor);
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:image.scale orientation:image.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

#pragma mark - Resize
- (UIImage *)autoResizableWidthForCenter{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, ceil(self.size.width/2), 0, ceil(self.size.width/2)+1);
    return  [self resizableImageWithCapInsets:insets];
}

- (UIImage *)autoResizableHeightForCenter{
    UIEdgeInsets insets = UIEdgeInsetsMake(ceil(self.size.height/2), 0, ceil(self.size.height/2)+1, 0);
    return  [self resizableImageWithCapInsets:insets];
}

- (UIImage *)autoResizableForCenter{
    UIEdgeInsets insets = UIEdgeInsetsMake(ceil(self.size.height/2), ceil(self.size.width/2), ceil(self.size.height/2)+1, ceil(self.size.width/2)+1);
    return  [self resizableImageWithCapInsets:insets];
}

- (UIImage *)resizeImageSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
    [self drawInRect:CGRectMake(0, 0.0, size.width, size.height)];
    
    // Generate a new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
