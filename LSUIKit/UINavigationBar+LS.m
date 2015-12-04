//
//  UINavigationBar+LS.m
//  LSUIKit
//
//  Created by liulihui on 15/9/11.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "UINavigationBar+LS.h"
#import "UIImage+LSPS.h"
#import <objc/runtime.h>

@interface UINavigationBar ()

@end

@implementation UINavigationBar (LS)

- (void)ls_ScrollingWithScrollView:(UIScrollView *)scrollView setBackgroundColor:(UIColor *)backgroundColor setDefalutColor:(UIColor *)defalutColor atTop:(CGFloat)top{
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        CGFloat offsetY = scrollView.contentOffset.y;
        self.hidden = NO;
        if (offsetY == .0) {
            [self ls_SetBackgroundColor:defalutColor];
        } else if (offsetY > 0) {
            if (offsetY < top) {
                CGFloat alpha = MIN(1, 1 - ((top - offsetY) / top));
                [self ls_SetBackgroundColor:[backgroundColor colorWithAlphaComponent:alpha]];
            } else {
                [self ls_SetBackgroundColor:[backgroundColor colorWithAlphaComponent:1]];
            }
        } else {
            self.hidden = YES;
            [self ls_SetBackgroundColor:[backgroundColor colorWithAlphaComponent:0]];
        }
    }
}

- (void)ls_ScrollingWithScrollView:(UIScrollView *)scrollView setBackgroundColor:(UIColor *)backgroundColor setDefalutImage:(UIImage *)defalutImage atTop:(CGFloat)top
{
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        CGFloat offsetY = scrollView.contentOffset.y;
        self.hidden = NO;
        BOOL isDefault = (offsetY == .0);
        if (!scrollView.decelerating) {
            isDefault  = ((offsetY == .0) || (offsetY == -64.0));
        }
        if (isDefault) {
            [self ls_SetBackgroundImage:defalutImage];
        } else if (offsetY > 0) {
            if (offsetY < top) {
                CGFloat alpha = MIN(1, 1 - ((top - offsetY) / top));
                [self ls_SetBackgroundColor:[backgroundColor colorWithAlphaComponent:alpha]];
            } else {
                [self ls_SetBackgroundColor:[backgroundColor colorWithAlphaComponent:1]];
            }
        } else {
            self.hidden = YES;
            [self ls_SetBackgroundColor:[backgroundColor colorWithAlphaComponent:0]];
        }
    }
}

- (void)ls_SetBackgroundColor:(UIColor *)backgroundColor
{
    [self ls_SetBackgroundImage:[UIImage createImageWithColor:backgroundColor]];
}

- (void)ls_SetBackgroundImage:(UIImage *)backgroundImage
{
    [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    self.translucent = YES;
}


@end
