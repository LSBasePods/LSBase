//
//  UINavigationController+LKSafe.m
//  LSFoundation
//
//  Created by 白开水_孙 on 15/8/31.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "UINavigationController+LKSafe.h"
#import "NSObject+RunTime.h"
#import <objc/runtime.h>

@implementation UINavigationController (LKSafe)
@dynamic allowPush;

- (void)setAllowPush:(BOOL)allowPush
{
    objc_setAssociatedObject(self, @selector(allowPush), @(allowPush), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)allowPush {
    id data = objc_getAssociatedObject(self, @selector(allowPush));
    if ([data respondsToSelector:@selector(boolValue)]) {
        return [data boolValue];
    }
    return YES;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector];
    });
}

+ (void)swizzleSelector
{
    [self swizzleInstanceMethod:@selector(initWithRootViewController:) with:@selector(LK_initWithRootViewController:)];
    [self swizzleInstanceMethod:@selector(pushViewController:animated:) with:@selector(LK_pushViewController:animated:)];
}

- (instancetype)LK_initWithRootViewController:(UIViewController *)rootViewController
{
    [self LK_initWithRootViewController:rootViewController];
    if (self) {
        self.delegate = self;        
    }
    return self;
}

- (void)LK_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.allowPush) {
        [self LK_pushViewController:viewController animated:animated];
        self.allowPush = NO;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.allowPush = YES;
}

@end
