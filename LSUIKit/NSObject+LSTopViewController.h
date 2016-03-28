//
//  NSObject+LSTopViewController.h
//  LSBaseExample
//
//  Created by liulihui on 16/2/18.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (LSTopViewController)

/**
 *  获取 windows.rootViewController;
 */
+ (UIViewController *)rootViewControllerInWindow;

/**
 *  等同于 returnVisibleViewControllerForController: windows.rootViewController;
 */
+ (UIViewController *)topViewControllerInWindow;

/**
 *  在指定页面获取当前显示页面
 *  @params controller      指定页面
 *  #return controller
 */
+ (UIViewController *)returnVisibleViewControllerForController:(UIViewController *)controller;

@end
