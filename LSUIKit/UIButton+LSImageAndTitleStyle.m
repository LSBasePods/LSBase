//
//  UIButton+LSImageAndTitleStyle.m
//  LSBaseExample
//
//  Created by liulihui on 16/1/18.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UIButton+LSImageAndTitleStyle.h"
#import "NSObject+RunTime.h"
#import <objc/runtime.h>
#import "UIView+LSFrame.h"

@implementation UIButton (LSImageAndTitleStyle)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector];
    });
}

+ (void)swizzleSelector
{
    [self swizzleInstanceMethod:@selector(layoutSubviews) with:@selector(LS_layoutSubviews)];
}

- (void)LS_layoutSubviews
{
    [self LS_layoutSubviews];
    
    switch (self.buttonStyle) {
        case LKButtonStyleLeftTextRightImage:
        {
            CGFloat left = floor(self.width - self.titleLabel.width - self.imageView.width) / 2.0;
            self.titleLabel.left = left;
            self.imageView.right = self.width - left;
            break;
        }
        case LKButtonStyleTopImageBottomText:
        {
            self.imageView.top = self.imageEdgeInsets.top;
            self.titleLabel.bottom = self.height - self.titleEdgeInsets.bottom;
            self.imageView.centerX = self.width / 2;
            self.titleLabel.centerX = self.width / 2;
            break;
        }
            
        default:
            break;
    }
    
}

- (void)setButtonStyle:(LSButtonStyle)buttonStyle
{
    objc_setAssociatedObject(self, "buttonStyle", @(buttonStyle), OBJC_ASSOCIATION_RETAIN);
}

- (LSButtonStyle)buttonStyle
{
    return [objc_getAssociatedObject(self, "buttonStyle") integerValue];
}

@end
