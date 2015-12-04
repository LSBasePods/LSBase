//
//  NSObject+LSDictionaryRepresentation.m
//  LSFoundation
//
//  Created by wysasun on 15/3/12.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "NSObject+LSDictionaryRepresentation.h"

@implementation NSObject (LSDictionaryRepresentation)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (NSMutableDictionary *)dictionaryRepresentation
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; ++ i) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            id value = [self valueForKey:key];
            dic[key] = value ? value : @"";
        }
    }
    return dic;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

#pragma clang diagnostic pop
@end
