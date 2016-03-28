//
//  UINavigationItem+LSCustomView.h
//  LSBaseExample
//
//  Created by liulihui on 16/3/28.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (LSCustomPadding)

+ (NSArray *)itemsWithBarButtonItem:(UIBarButtonItem *)item widthToboundary:(CGFloat)width;

@end
