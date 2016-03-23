//
//  NSObject+LSTopViewController.m
//  LSBaseExample
//
//  Created by liulihui on 16/2/18.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "NSObject+LSTopViewController.h"

@implementation NSObject (LSTopViewController)

+ (UIViewController *)topViewControllerInWindow
{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    UIViewController *topViewController = [UIViewController returnVisibleViewControllerForController:windows.rootViewController];
    return topViewController;
}

+ (UIViewController *)returnVisibleViewControllerForController:(UIViewController *)controller
{
    if ([controller presentedViewController]) {
        return [self returnVisibleViewControllerForController:[controller presentedViewController]];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        return [self returnVisibleViewControllerForController:[(UITabBarController *)controller selectedViewController]];
    } else if ([controller isKindOfClass:[UINavigationController class]]) {
        return [self returnVisibleViewControllerForController:[(UINavigationController *)controller topViewController]];
    } else {
        return controller;
    }
}

@end
