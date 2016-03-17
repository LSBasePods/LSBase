//
//  NSNumber+LS.m
//  LSFoundation
//
//  Created by liulihui on 15/9/24.
//  Copyright © 2015年 BasePod. All rights reserved.
//

#import "NSNumber+LS.h"

@implementation NSNumber (LS)

- (NSString *)priceValue
{
    return [NSString stringWithFormat:@"%.2f", [self doubleValue]];
}

- (BOOL)isEqualToNumberSafe:(NSNumber *)number
{
    if (number) {
        return [self isEqualToNumber:number];
    }
    return NO;
}

@end
