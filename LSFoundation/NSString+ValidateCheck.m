//
//  NSString+ValidateCheck.m
//  LSFoundation
//
//  Created by liulihui on 15/2/5.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "NSString+ValidateCheck.h"

@implementation NSString (ValidateCheck)

- (BOOL)isValidateRegex:(NSString *)regex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidateMobileNumber
{
    NSString *regex = @"^1[0-9]{10}$";
    return [self isValidateRegex:regex];
}

- (BOOL)isValidateEmail
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateRegex:regex];
}

- (NSString *)displaySafeMobile
{
    if ([self isValidateMobileNumber]) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return self;
}

@end
