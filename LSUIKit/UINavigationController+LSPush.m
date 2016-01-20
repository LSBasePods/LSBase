//
//  UINavigationController+LSPush.m
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/20.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UINavigationController+LSPush.h"

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

@end
