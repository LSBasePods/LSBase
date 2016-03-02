//
//  NSDictionary+LSTrim.m
//  LSFoundation
//
//  Created by liulihui on 15/1/8.
//
//

#import "NSDictionary+LS.h"
#import "NSObject+LSValueCheck.h"

@implementation NSDictionary (LS)

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

- (NSString *)toStringWithSplitString:(NSString *)splitString
{
    NSString *string = @"";
    for (NSString *key in self.allKeys) {
        if (string.length > 0 && splitString) {
            string = [string stringByAppendingString:splitString];
        }
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            string = [NSString stringWithFormat:@"%@%@=%@", string, key, value];
        } else if ([value isKindOfClass:[NSNumber class]]){
            string = [NSString stringWithFormat:@"%@%@=%@", string, key, [value stringValue]];
        }
    }
    return string;
}

@end
