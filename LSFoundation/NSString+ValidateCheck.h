//
//  NSString+ValidateCheck.h
//  LSFoundation
//
//  Created by liulihui on 15/2/5.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ValidateCheck)

/**
 *  正则判断是否合法
 *
 *  @param regex 正则表达式
 *
 */
- (BOOL)isValidateRegex:(NSString *)regex;

/**
 *  正则判断手机号是否合法
 */
- (BOOL)isValidateMobileNumber;

/**
 *  正则判断邮箱是否合法
 */
- (BOOL)isValidateEmail;

/**
 *  手机号替换第三位到第六位为*
 */
- (NSString *)displaySafeMobile;


@end
