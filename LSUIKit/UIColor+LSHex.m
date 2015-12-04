//
//  UIColor+LSHex.m
//  LSUIKit
//
//  Created by liulihui on 15/6/4.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "UIColor+LSHex.h"

@implementation UIColor (LSHex)

+ (UIColor *)colorWithHex:(uint) hex alpha:(CGFloat)alpha
{
    int red, green, blue;
    
    blue = hex & 0x0000FF;
    green = ((hex & 0x00FF00) >> 8);
    red = ((hex & 0xFF0000) >> 16);
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end
