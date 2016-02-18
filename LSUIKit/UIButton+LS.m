//
//  UIButton+LS.m
//  LSBaseExample
//
//  Created by liulihui on 16/2/18.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UIButton+LS.h"

@implementation UIButton (LS)

- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont forState:(UIControlState)forState
{
    [self setTitleColor:titleColor forState:forState];
    [self setTitle:title forState:forState];
    self.titleLabel.font = titleFont;
}

@end
