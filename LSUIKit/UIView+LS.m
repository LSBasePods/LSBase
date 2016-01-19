//
//  UIView+LS.m
//  LSUIKit
//
//  Created by liulihui on 15/6/4.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "UIView+LS.h"
#import <objc/runtime.h>

@implementation NSObject (ViewModelMapping)

+ (void)view:(UIView *)view mappingModel:(id)data
{
    
}

@end

@implementation UIView (LS)

+ (NSString *)className
{
    return NSStringFromClass([self class]);
}

- (UIViewController *)myViewController
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)configViewFromData:(id)data
{
    NSString *className = NSStringFromClass([self class]);
    NSString *classViewMapping = [className stringByAppendingString:@"Mapping"];
    Class mappingClass = NSClassFromString(classViewMapping);
    [mappingClass view:self mappingModel:data];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, "indexPath", indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath
{
    return objc_getAssociatedObject(self, "indexPath");
}

- (void)setLsUserInfo:(id)lsUserInfo
{
    objc_setAssociatedObject(self, "lsUserInfo", lsUserInfo, OBJC_ASSOCIATION_RETAIN);
}

- (id)lsUserInfo
{
    return objc_getAssociatedObject(self, "lsUserInfo");
}

@end
