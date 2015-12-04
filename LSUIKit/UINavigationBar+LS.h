//
//  UINavigationBar+LS.h
//  LSUIKit
//
//  Created by liulihui on 15/9/11.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (LS)

- (void)ls_ScrollingWithScrollView:(UIScrollView *)scrollView setBackgroundColor:(UIColor *)backgroundColor setDefalutColor:(UIColor *)defalutColor atTop:(CGFloat)top;

- (void)ls_ScrollingWithScrollView:(UIScrollView *)scrollView setBackgroundColor:(UIColor *)backgroundColor setDefalutImage:(UIImage *)defalutImage atTop:(CGFloat)top;

- (void)ls_SetBackgroundColor:(UIColor *)backgroundColor;
- (void)ls_SetBackgroundImage:(UIImage *)backgroundImage;

@end
