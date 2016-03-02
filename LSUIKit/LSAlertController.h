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

@property (nonatomic, readonly) NSArray<LSAlertAction *> *actions;
@property (nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readonly) LSAlertControllerStyle preferredStyle;

+ (id)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LSAlertControllerStyle)preferredStyle;

- (void)addAction:(LSAlertAction *)alertAction;

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

- (void)showInController:(UIViewController *)controller;

@end
