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

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, "indexPath", indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath
{
    return objc_getAssociatedObject(self, "indexPath");
}

- (void)setLsUserInfo:(NSDictionary *)lsUserInfo
{
    objc_setAssociatedObject(self, "lsUserInfo", lsUserInfo, OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)lsUserInfo
{
    return objc_getAssociatedObject(self, "lsUserInfo");
}

@end
