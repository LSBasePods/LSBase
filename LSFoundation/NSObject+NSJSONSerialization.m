//
//  NSObject+NSJSONSerialization.m
//  LSFoundation
//
//  Created by liulihui on 14/12/11.
//  Copyright (c) 2014年 BasePod. All rights reserved.
//

#import "NSObject+NSJSONSerialization.h"

@implementation NSObject (NSJSONSerialization)

- (NSString *)LSJSONRepresentation {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        NSLog(@"RTJSONRepresentation error: %@", error);
        return @"";
    }
    
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end

@implementation NSString (NSJSONSerialization)

- (id)LSJSONValue {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!jsonObject) {
        NSLog(@"JSONValue error: %@", error);
        return nil;
    }
    
    return jsonObject;
}

@end
