//
//  UIImage+LSPS.h
//  LSUIKit
//
//  Created by liulihui on 15/6/4.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LSPS)

#pragma mark - Create
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createMaskWithImage:(UIImage *)image outColor:(UIColor *)outColor innerColor:(UIColor *)innerColor;

#pragma mark - Resize
- (UIImage *)autoResizableWidthForCenter;
- (UIImage *)autoResizableHeightForCenter;
- (UIImage *)autoResizableForCenter;
- (UIImage *)resizeImageSize:(CGSize)size;

@end
