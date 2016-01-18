//
//  UINavigationController+LSSafe.h
//  LSFoundation
//
//  Created by 白开水_孙 on 15/8/31.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  防止UINavigationController多次快速点击做多次跳转操作
 */
@interface UINavigationController (LSSafe)<UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL allowPush;
@end
