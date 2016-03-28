//
//  UINavigationItem+LSCustomView.m
//  LSBaseExample
//
//  Created by liulihui on 16/3/28.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UINavigationItem+LSCustomPadding.h"

@implementation UINavigationItem (LSCustomView)

+ (NSArray *)itemsWithBarButtonItem:(UIBarButtonItem *)item widthToboundary:(CGFloat)width
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    CGFloat defaultWidth = -16;
    negativeSpacer.width = defaultWidth - width;
    return @[negativeSpacer, item];
}
@end
