//
//  NSString+URLQueryResolver.m
//  LSFoundation
//
//  Created by 白开水_孙 on 15/5/25.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "NSString+URLQueryResolver.h"

@implementation NSString (URLQueryResolver)

- (NSDictionary *)p_createQueryDictionary
{
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    NSArray *array = [self componentsSeparatedByString:@"&"];
    for (NSString *str in array) {
        NSRange rang = [str rangeOfString:@"="];
        if (rang.location != NSNotFound) {
            NSString *key = [str substringWithRange:NSMakeRange(0, rang.location)];
            NSInteger loc = rang.location + 1;
            NSString *value = [str substringWithRange:NSMakeRange(loc, str.length - loc)];
            value = [value QR_urlDecode];
            [temp setObject:value forKey:key];
        }
    }
    return  temp;
}

- (NSDictionary *)QR_queryItems
{
    NSRange range = [self rangeOfString:@"?"];
    NSString *paramsString = self;
    if (range.location != NSNotFound) {
        paramsString = [self substringFromIndex:range.location + 1];
    }
    return [paramsString p_createQueryDictionary];
}

- (NSString *)QR_urlDecode{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString *)QR_urlEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    size_t sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
@end
