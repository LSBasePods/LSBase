//
//  LSFObject.m
//  LSFoundation
//
//  Created by wysasun on 15/3/12.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "LSFObject.h"

@implementation LSFObject
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (NSMutableDictionary *)dictionaryRepresentation
{
    return [self detailInfo];
}

- (NSMutableDictionary *)detailInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *key in [[self class] allPropertyKeys]) {
        id value = [self valueForKey:key];
        dic[key] = value ? value : @"";
    }
    
    return dic;
}

#pragma clang diagnostic pop

+ (NSMutableDictionary *)writablePropertyKeys {
    NSMutableDictionary *keyPairs = [NSMutableDictionary dictionary];
    [self enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL *stop) {
        const char *propertyAttributes = property_getAttributes(property);
        NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
        if (![attributes containsObject:@"R"]) {
            NSString *key = @(property_getName(property));
            
            NSString * typeAttribute = [attributes objectAtIndex:0];
            NSString * propertyType = [typeAttribute substringFromIndex:1];
            const char * rawPropertyType = [propertyType UTF8String];
            
            NSString *classString = nil;
            if ([typeAttribute hasPrefix:@"T@"]) {
                if (typeAttribute.length <= 4) {
                    return;
                }
                NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
                Class typeClass = NSClassFromString(typeClassName);
                if (typeClass) {
                    classString = typeClassName;
                }
            } else if (!strcmp(rawPropertyType, @encode(BOOL))) {
                classString = @"BOOL";
            } else {
                NSAssert5(NO, @"LSModel的子类的读写属性只滋糍一下几种类型：%@，%@，%@，%@，%@", @"NSString", @"NSNumber", @"BOOL", @"LSModel的子类", @"LSModel的子类的数组");
            }
            [keyPairs setObject:classString forKey:key];
        }
    }];
    
    return keyPairs;
}

+ (NSSet *)allPropertyKeys {
    NSMutableSet *keys = [NSMutableSet set];
    [self enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL *stop) {
        //        const char *propertyAttributes = property_getAttributes(property);
        //        NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes] componentsSeparatedByString:@","];
        NSString *key = @(property_getName(property));
        [keys addObject:key];
    }];
    
    return keys;
}

+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block
{
    Class cls = self;
    BOOL stop = NO;
    
    while (!stop && [cls isSubclassOfClass:[LSFObject class]]) {
        unsigned count = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        
        cls = cls.superclass;
        if (properties == NULL) continue;
        for (unsigned i = 0; i < count; i++) {
            block(properties[i], &stop);
            if (stop) {
                break;
            }
        }
        free(properties);
    }
}

@end