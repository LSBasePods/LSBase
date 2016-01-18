//
//  UIButton+LSImageAndTitleStyle.h
//  LSBaseExample
//
//  Created by liulihui on 16/1/18.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LSButtonStyle) {
    LKButtonStyleDefault = 0,               //!< 图片左边，文字右边
    LKButtonStyleLeftTextRightImage,        //!< 文字左边，图片右边
    LKButtonStyleTopImageBottomText         //!< 文字下边，图片上边
};

@interface UIButton (LSImageAndTitleStyle)

@property (nonatomic, assign) LSButtonStyle buttonStyle;

@end
