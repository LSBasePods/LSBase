//
//  NSDictionary+LSTrim.m
//  LSFoundation
//
//  Created by liulihui on 15/1/8.
//
//

#import "NSDictionary+LSTrim.h"
#import "NSObject+LSValueCheck.h"

@implementation NSDictionary (LSTrim)

- (id)trim
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self];
    NSArray *allKey = self.allKeys;
    [allKey enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = [self objectForKey:obj];
        if (![self isValidateObject:obj] || ![self isValidateObject:value]) {
            [tempDic removeObjectForKey:obj];
        }
    }];
    return tempDic;
}

@end
