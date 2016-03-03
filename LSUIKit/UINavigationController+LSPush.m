//
//  UINavigationController+LSPush.m
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/20.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UINavigationController+LSPush.h"
#import "NSArray+LSSafeObjectAtIndex.h"

@implementation UINavigationController (LSPush)

- (void)lsPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.delegate = self;
    viewController.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.topViewController.navigationItem.backBarButtonItem = backItem;
    for(UIView *temp in self.navigationBar.subviews)
    {
        [temp setExclusiveTouch:YES];
    }
    [self pushViewController:viewController animated:animated];
}

- (void)lsPopToViewControllerForIndex:(NSInteger)index animated:(BOOL)animated
{
    NSInteger count = self.viewControllers.count;
    UIViewController *controller = [self.viewControllers safeObjectAtIndex:(count - index - 1)];
    if (controller) {
        [self popToViewController:controller animated:animated];
    } else {
        [self popToRootViewControllerAnimated:animated];
    }
}

@end
