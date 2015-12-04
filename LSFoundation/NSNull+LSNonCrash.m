//
//  NSNull+LSNonCrash.m
//  LSFoundation
//
//  Created by 白开水_孙 on 8/11/15.
//  Copyright (c) 2015 BasePod All rights reserved.
//

#import "NSNull+LSNonCrash.h"

@implementation NSNull (LSNonCrash)
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self];
    }
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [[NSNull class] instanceMethodSignatureForSelector:aSelector];
    if(sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^@cq"];
    }
    return sig;
}
@end
