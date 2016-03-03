//
//  LSAlertController.h
//  LSBaseExample
//
//  Created by liulihui on 16/3/1.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LSAlertActionStyle) {
    LSAlertActionStyleDefault = 0,
    LSAlertActionStyleCancel,
    LSAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, LSAlertControllerStyle) {
    LSAlertControllerStyleActionSheet = 0,
    LSAlertControllerStyleAlert
};

@interface LSAlertAction : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign) LSAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(LSAlertAction *action);

+ (instancetype)actionWithTitle:(NSString *)title style:(LSAlertActionStyle)style handler:(void (^)(LSAlertAction *action))handler;


@end

@interface LSAlertController : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) LSAlertControllerStyle preferredStyle;

/**
 *  显示提示信息
 *  @param  title           标题
 *  @param  message         内容
 *  @param  buttonTitle     按钮标题
 *  @param  controller      显示页面
 */
+ (void)showNoticeAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle inController:(UIViewController *)controller;

/**
 *  初始化弹出框
 *  @param  title               标题
 *  @param  message             内容
 *  @param  preferredStyle      UI样式
 */
+ (id)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LSAlertControllerStyle)preferredStyle;

/**
 *  添加按钮
 *  @param  alertAction               按钮
 */
- (void)addAction:(LSAlertAction *)alertAction;

/**
 *  添加输入框，只在iOS8.0之后有效
 *  @param  configurationHandler               回调
 */
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler NS_AVAILABLE_IOS(8_0);

/**
 *  显示弹出框
 *  @param  controller               显示页面
 */
- (void)showInController:(UIViewController *)controller;

@end
