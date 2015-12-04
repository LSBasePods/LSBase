//
//  NSString+TreatAsNSNumber.m
//  LSFoundation
//
//  Created by 白开水_孙 on 15/9/22.
//  Copyright © 2015年 BasePod. All rights reserved.
//

#import "NSString+TreatAsNSNumber.h"

@implementation NSString (TreatAsNSNumber)
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(isEqualToNumber:)) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *number = [formatter numberFromString:self];
        return number;
    }
    return nil;
}
@end
