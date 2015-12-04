//
//  NSArray+LSSafeObjectAtIndex.m
//  LSFoundation
//
//  Created by wysasun on 15/3/12.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "NSArray+LSSafeObjectAtIndex.h"
#import "NSObject+RunTime.h"

@implementation NSArray (LSSafeObjectAtIndex)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector];
    });
}

+ (void)swizzleSelector
{
    [self swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) with:@selector(LSF_objectAtIndexedSubscript:)];
}

/**
 *  超载下标操作,debug版本中越界报错，release版本中读取数组越界返回nil,不产生crash
 *
 *  @param idx 需要查询的index
 *
 *  @return 如果index越界返回nil，否则返回原值
 */
- (id)LSF_objectAtIndexedSubscript:(NSUInteger)idx
{
    if (idx >= self.count) {
#ifdef DEBUG
        [NSException raise:NSRangeException format:@"*** -[%@ objectAtIndex:]: index %lu beyond bounds for array %@", NSStringFromClass([self class]), (unsigned long)idx, self];
#endif
        return nil;
    }
    return [self LSF_objectAtIndexedSubscript:idx];
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}
@end
