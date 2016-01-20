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

@end
