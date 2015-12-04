//
//  NSMutableArray+LSSafeSetObjectAtIndexed.m
//  LSFoundation
//
//  Created by wysasun on 15/3/12.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "NSMutableArray+LSSafeSetObjectAtIndexed.h"
#import "NSObject+RunTime.h"

@implementation NSMutableArray (LSSafeSetObjectAtIndexed)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector];
    });
}

+ (void)swizzleSelector
{
    [self swizzleInstanceMethod:@selector(setObject:atIndexedSubscript:) with:@selector(LSF_setObject:atIndexedSubscript:)];
}

/**
 *  超载下标赋值操作,release版本中存入nil、越界不报错
 *
 *  @param obj 需要设置的值
 *  @param idx index
 */
- (void)LSF_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    if (!obj) {
#ifdef DEBUG
        [NSException raise:NSRangeException format:@"*** -[%@ setObject:atIndex:]: object cannot be nil", NSStringFromClass([self class])];
#endif
        return;
    }
    if (idx > self.count) {
#ifdef DEBUG
        [NSException raise:NSRangeException format:@"*** -[%@ setObject:atIndex:]: index %lu beyond bounds for array %@", NSStringFromClass([self class]), (unsigned long)idx, self];
#endif
        return;
    }
    
    return [self LSF_setObject:obj atIndexedSubscript:idx];
}
@end
