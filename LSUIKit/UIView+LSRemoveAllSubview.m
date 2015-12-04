//
//  UIView+LSRemoveAllSubview.m
//  LSUIKit
//
//  Created by liulihui on 15/6/4.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "UIView+LSRemoveAllSubview.h"

@implementation UIView (LSRemoveAllSubview)

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
