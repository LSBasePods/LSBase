//
//  UIView+LSBorder.h
//  LSBaseExample
//
//  Created by liulihui on 16/2/16.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, LSBorderPosition) {
    LSBorderPositionAll         = 0,
    LSBorderPositionTop         = 1 << 0,
    LSBorderPositionLeft        = 1 << 1,
    LSBorderPositionBottom      = 1 << 2,
    LSBorderPositionRight       = 1 << 3
};


@interface UIView (LSBorder)

- (void)showBorderPosition:(LSBorderPosition)borderPositions borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets;
- (void)showTopBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets;
- (void)showBottomBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets;
- (void)showLeftBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets;
- (void)showRightBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets;

@end
