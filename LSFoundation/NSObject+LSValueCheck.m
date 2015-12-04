//
//  NSObject+LSValueCheck.m
//  LSFoundation
//
//  Created by liulihui on 14/12/24.
//  Copyright (c) 2014年 BasePod. All rights reserved.
//

#import "NSObject+LSValueCheck.h"

@implementation NSObject (LSValueCheck)

- (BOOL)isValidateObject:(id)object
{
    if ([object isEqual:[NSNull null]] || object == nil) {
        return NO;
    }
    if ([object isKindOfClass:[NSString class]] && ([@"" isEqualToString:(NSString *)object] || [@"0" isEqualToString:(NSString *)object])) {
        return NO;
    }
    if ([object isKindOfClass:[NSNumber class]] && [object isEqualToNumber:@(0)]) {
        return NO;
    }
    return YES;
}

+ (id)checkValue:(id)value defaultValue:(id)defaultValue
{
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    return [value defaultValue:defaultValue];
}

- (id)defaultValue:(id)value
{
    Class defaultDataClass;
    if ([value isKindOfClass:[NSNumber class]]) {
        defaultDataClass = [NSNumber class];
    } else if ([value isKindOfClass:[NSString class]]) {
        defaultDataClass = [NSString class];
        if ([self isKindOfClass:defaultDataClass] && [(NSString *)self isEqualToString:@"null"]) {
            return @"";
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        defaultDataClass = [NSArray class];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        defaultDataClass = [NSDictionary class];
    }
    
    //如果获取的值与默认值的类型不同，直接返回默认值
    if (value && ![self isKindOfClass:defaultDataClass]) {
        return value;
    }
    
    if ([self isEqual:[NSNull null]] || self == nil) {
        return value;
    }
    return self;
}


@end
