//
//  LSAlertController.m
//  LSBaseExample
//
//  Created by liulihui on 16/3/1.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "LSAlertController.h"
#import "LSMacros.h"
#import "NSObject+LSTopViewController.h"

@interface LSAlertAction ()

@property (nonatomic, copy) NSString *title;

@end

@implementation LSAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(LSAlertActionStyle)style handler:(void (^)(LSAlertAction *action))handler
{
    LSAlertAction *action = [LSAlertAction new];
    action.title = title;
    action.style = style;
    action.handler = handler;
    return action;
}

@end

@interface LSAlertController ()<UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, assign) LSAlertControllerStyle preferredStyle;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *destructiveTitle;


@end


@implementation LSAlertController

+ (LSAlertController *)sharedInstance
{
    static LSAlertController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LSAlertController alloc] init];
    });
    return instance;
}

+ (void)showNoticeAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle inController:(UIViewController *)controller
{
    LSAlertController *alertController = [LSAlertController alertControllerWithTitle:title message:message preferredStyle:LSAlertControllerStyleAlert];
    LSAlertAction *okAction = [LSAlertAction actionWithTitle:buttonTitle style:LSAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController showInController:controller];
}

+ (id)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(LSAlertControllerStyle)preferredStyle
{
    LSAlertController *alert = [self sharedInstance];
    alert.title = title;
    alert.message = message;
    alert.preferredStyle = preferredStyle;
    alert.buttons = nil;
    alert.cancelTitle = nil;
    alert.destructiveTitle = nil;
    if ([self useUIAlertController]) {
        alert.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyle)preferredStyle];
    } else {
        if (alert.preferredStyle == LSAlertControllerStyleAlert) {
            alert.alertView = nil;
        } else {
            alert.actionSheet = nil;
        }
    }
    return alert;
}

- (void)addAction:(LSAlertAction *)alertAction
{
    if ([LSAlertController useUIAlertController]) {
        UIAlertAction *new = [UIAlertAction actionWithTitle:alertAction.title style:(UIAlertActionStyle)alertAction.style handler:^(UIAlertAction * _Nonnull action) {
            alertAction.handler ? alertAction.handler(alertAction) : nil;
        }] ;
        [self.alertController addAction:new];
    } else {
        NSString *title = alertAction.title;
        switch (alertAction.style) {
            case LSAlertActionStyleCancel:
            {
                self.cancelTitle = title;
            }
                break;
            case LSAlertActionStyleDestructive:
            {
                if (self.preferredStyle == LSAlertControllerStyleActionSheet) {
                    if (self.destructiveTitle.length > 0) {
                        alertAction.style = LSAlertActionStyleDefault;
                    } else {
                        self.destructiveTitle = title;
                    }
                }
            }
            default:
                break;
        }
        if ([alertAction isKindOfClass:[LSAlertAction class]]) {
            [self.buttons addObject:alertAction];
        }
    }
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler
{
    if ([LSAlertController useUIAlertController]) {
        [self.alertController addTextFieldWithConfigurationHandler:configurationHandler];
    } else {
        
    }
}

- (void)showInController:(UIViewController *)controller
{
    if ([LSAlertController useUIAlertController]) {
        [controller presentViewController:(UIAlertController *)self.alertController animated:YES completion:nil];
    } else {
        if (self.preferredStyle == LSAlertControllerStyleAlert) {
            self.alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:self.cancelTitle otherButtonTitles:nil];
            
            for (LSAlertAction *action in self.buttons) {
                if (action.style != LSAlertActionStyleCancel) {
                    [self.alertView addButtonWithTitle:action.title];
                }
            }
            [self.alertView show];
        } else {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:self.cancelTitle destructiveButtonTitle:self.destructiveTitle otherButtonTitles:nil];
            for (LSAlertAction *action in self.buttons) {
                if (action.style == LSAlertActionStyleDefault) {
                    [self.actionSheet addButtonWithTitle:action.title];
                }
            }
            [self.actionSheet showInView:controller.view];
        }
    }
}

+ (BOOL)useUIAlertController
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    for (LSAlertAction *action in self.buttons) {
        if ([title isEqualToString:action.title]) {
            action.handler ? action.handler(action) : nil;
        }
    }
    self.actionSheet = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    for (LSAlertAction *action in self.buttons) {
        if ([title isEqualToString:action.title]) {
            action.handler ? action.handler(action) : nil;
        }
    }
    self.alertView = nil;
}

#pragma mark - Init
- (NSArray *)actions
{
    return self.buttons;
}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray new];
    }
    return _buttons;
}

@end
