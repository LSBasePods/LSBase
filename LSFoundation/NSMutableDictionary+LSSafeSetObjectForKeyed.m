//
//  NSMutableDictionary+LSSafeSetObjectForKeyed.m
//  LSFoundation
//
//  Created by wysasun on 15/3/12.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "NSMutableDictionary+LSSafeSetObjectForKeyed.h"
#import "NSObject+RunTime.h"

@implementation NSMutableDictionary (LSSafeSetObjectForKeyed)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector];
    });
}

+ (void)swizzleSelector
{
    [self swizzleInstanceMethod:@selector(setObject:forKeyedSubscript:) with:@selector(LSF_setObject:forKeyedSubscript:)];
    [[NSClassFromString(@"__NSPlaceholderDictionary") class] swizzleInstanceMethod:@selector(initWithObjects:forKeys:count:) with:@selector(LSF_initWithObjects:forKeys:count:)];
}

- (instancetype)LSF_initWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt
{
    
    id newObject[cnt];
    id <NSCopying> newKeys[cnt];
    int count = 0;
    for (int i = 0; i < cnt; i++) {
        id object = objects[i];
        id key = keys[i];
        if (object && key) {
            newObject[count] = object;
            newKeys[count ++] = key;
        }
    }
    
    id result = [self LSF_initWithObjects:newObject forKeys:newKeys count:count];
    return result;
}

/**
 *  重载下标赋值操作,存入nil在release版本中直接返回，不报错
 *
 *  @param value 需要存入的值
 *  @param key   对应的key
 */
- (void)LSF_setObject:(id)value forKeyedSubscript:(id <NSCopying>)key
{
    if (!value) {
#ifdef DEBUG
        //先去掉了，iOS9不知道为啥老是**的报错
        //[NSException raise:NSRangeException format:@"*** -[%@ etObject:forKeyedSubscript:]: can't set nil value to key %@", NSStringFromClass([self class]), key];
#endif
        return;
    }
    return [self LSF_setObject:value forKeyedSubscript:key];
}
@end
