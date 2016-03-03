//
//  UINavigationController+LSPush.h
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/20.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+LSSafe.h"

@interface UINavigationController (LSPush)

- (void)lsPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 *  回退index页面
 *  @param  index 回退几个页面
 *  @param  animated 是否显示动效
 */
- (void)lsPopToViewControllerForIndex:(NSInteger)index animated:(BOOL)animated;

@end
