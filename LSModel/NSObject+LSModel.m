//
//  NSObject+LSModel.m
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/4.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "NSObject+LSModel.h"
#import <objc/runtime.h>
#import "YYClassInfo.h"

#define force_inline __inline__ __attribute__((always_inline))

/// Whether the type is c number.
static force_inline BOOL LSEncodingTypeIsCNumber(YYEncodingType type) {
    switch (type & YYEncodingTypeMask) {
        case YYEncodingTypeBool:
        case YYEncodingTypeInt8:
        case YYEncodingTypeUInt8:
        case YYEncodingTypeInt16:
        case YYEncodingTypeUInt16:
        case YYEncodingTypeInt32:
        case YYEncodingTypeUInt32:
        case YYEncodingTypeInt64:
        case YYEncodingTypeUInt64:
        case YYEncodingTypeFloat:
        case YYEncodingTypeDouble:
        case YYEncodingTypeLongDouble: return YES;
        default: return NO;
    }
}

@implementation NSObject (LSModel)

#pragma mark - Public Methods
+ (instancetype)modelWithJSON:(id)json
{
    return [self modelWithJSON:json discrepantKeys:0];
}

+ (instancetype)modelWithJSON:(id)json discrepantKeys:(NSDictionary *)discrepantKeys
{
    NSDictionary *dic = [self _ls_dictionaryWithJSON:json];
    return [self modelWithDictionary:dic discrepantKeys:discrepantKeys];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary
{
    return [self modelWithDictionary:dictionary discrepantKeys:0];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary discrepantKeys:(NSDictionary *)discrepantKeys
{
    if (!dictionary || dictionary == (id)kCFNull) return nil;
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    
    if (!discrepantKeys && class_getClassMethod(self, @selector(discrepantKeys))) {
        discrepantKeys = [((id<LSModel>)self) discrepantKeys];
    }
    
    Class cls = [self class];
    
    //TODO Cached Class
    
    NSObject *one = [cls new];
    
    // 拦截自动设置，手动设置model set
    if ([one respondsToSelector:@selector(customModelSetWithDictionary:)]) {
        [((id<LSModel>)one) customModelSetWithDictionary:dictionary];
        return one;
    }
    
    if ([one modelSetWithDictionary:dictionary discrepantKeys:discrepantKeys]) {
        return one;
    }
    
    return nil;
}

+ (instancetype)modelWithOtherObject:(id)object
{
    return [self modelWithOtherObject:object discrepantKeys:0];
}

+ (instancetype)modelWithOtherObject:(id)object discrepantKeys:(NSDictionary *)discrepantKeys
{
    if (!discrepantKeys && class_getClassMethod(self, @selector(discrepantKeys))) {
        discrepantKeys = [((id<LSModel>)self) discrepantKeys];
    }
    
    Class cls = [self class];
    
    //TODO Cached Class
    
    NSObject *one = [cls new];
    
    // 拦截自动设置，手动设置model
    if ([one respondsToSelector:@selector(customModelSetWithOtherObject:)]) {
        [((id<LSModel>)one) customModelSetWithOtherObject:object];
        return one;
    }
    
    if ([one modelSetWithOtherObject:object discrepantKeys:discrepantKeys]) {
        return one;
    }

    return 0;
}

- (BOOL)modelSetWithJSON:(id)json
{
    return [self modelSetWithJSON:json discrepantKeys:0];
}

- (BOOL)modelSetWithJSON:(id)json discrepantKeys:(NSDictionary *)discrepantKeys
{
    NSDictionary *dic = [[self class] _ls_dictionaryWithJSON:json];
    return [self modelSetWithDictionary:dic discrepantKeys:discrepantKeys];
}

- (BOOL)modelSetWithDictionary:(NSDictionary *)dic
{
    return [self modelSetWithDictionary:dic discrepantKeys:0];
}

- (BOOL)modelSetWithDictionary:(NSDictionary *)dic discrepantKeys:(NSDictionary *)discrepantKeys
{
    if (!dic || dic == (id)kCFNull) return NO;
    if (![dic isKindOfClass:[NSDictionary class]]) return NO;
    
    if (!discrepantKeys && class_getClassMethod([self class], @selector(discrepantKeys))) {
        discrepantKeys = [([(id<LSModel>)self class]) discrepantKeys];
    }
    
    if (!discrepantKeys && class_getClassMethod([self class], @selector(discrepantKeys))) {
        discrepantKeys = [([(id<LSModel>)self class]) discrepantKeys];
    }
    
    NSDictionary *writablePropertyInfos = [[self class] _ls_writablePropertiyInfos];
    for (NSString *nativeKey in writablePropertyInfos) {
        YYClassPropertyInfo *nativePropertyInfo = writablePropertyInfos[nativeKey];
        NSString *remoteKey = discrepantKeys[nativeKey] ? : nativeKey;
        id remoteValue = [dic valueForKey:remoteKey];
        if (remoteValue) {
            // 基本类型数字处理
            if (LSEncodingTypeIsCNumber(nativePropertyInfo.type)) {
                [self setValue:remoteValue forKey:nativeKey];
            } else if (nativePropertyInfo.type & YYEncodingTypeObject) {
                NSString *nativeTypeClassName = [nativePropertyInfo.typeEncoding substringWithRange:NSMakeRange(2, nativePropertyInfo.typeEncoding.length - 3)];
                Class nativeType = NSClassFromString(nativeTypeClassName);
                // 类型一致
                if ([remoteValue isKindOfClass:nativeType]) {
                    // 类型一致直接赋值
                    [self setValue:remoteValue forKey:nativeKey];
                } else {
                    //类型不一致
                    if (nativeType == [NSString class] && ![remoteValue isKindOfClass:nativeType]) {
                        // 容错 : nativie:NSString ; remote:NSNumber
                        NSAssert(NO, @"NSString is excepted for %@:%@ while %@ given", [self class], nativeKey, [remoteValue class]);
                        remoteValue = [NSString stringWithFormat:@"%@", remoteValue];
                        [self setValue:remoteValue forKey:nativeKey];
                    } else if (nativeType == [NSNumber class] && ![remoteValue isKindOfClass:nativeType]) {
                        // 容错 : native:NSNumber ; remote:NSString
                        NSAssert(NO, @"NSNumber is excepted for %@:%@ while %@ given", [self class], nativeKey, [remoteValue class]);
                        NSNumberFormatter *formatter = [NSNumberFormatter new];
                        remoteValue = [formatter numberFromString:remoteKey];
                        [self setValue:remoteValue forKey:nativeKey];
                    } else if ([remoteValue isKindOfClass:[NSDictionary class]]){
                        //  转为其他model
                        remoteValue = [nativeType modelWithDictionary:remoteValue];
                        [self setValue:remoteValue forKey:nativeKey];
                    } else {
                        // 暂时无法处理
                        if (nativeType) {
                            NSAssert(NO, @"Diff Class in Model:%@ ! Native type:%@ name:%@ ,Remote type:%@", [self class], nativeType, nativeKey, [remoteValue class]);
                        }
                    }
                }
            }
        }
    }
    
    return YES;
}

- (BOOL)modelSetWithOtherObject:(id)object
{
    return [self modelSetWithOtherObject:object discrepantKeys:0];
}

- (BOOL)modelSetWithOtherObject:(id)object discrepantKeys:(NSDictionary *)discrepantKeys
{
    if (!discrepantKeys && class_getClassMethod([self class], @selector(discrepantKeys))) {
        discrepantKeys = [([(id<LSModel>)self class]) discrepantKeys];
    }
    
    NSDictionary *writablePropertyInfos = [[self class] _ls_writablePropertiyInfos];
    for (NSString *nativeKey in writablePropertyInfos) {
        YYClassPropertyInfo *nativePropertyInfo = writablePropertyInfos[nativeKey];
        NSString *remoteKey = discrepantKeys[nativeKey] ? : nativeKey;
        id remoteValue = [object valueForKey:remoteKey];
        if (remoteValue) {
            // 基本类型数字处理
            if (LSEncodingTypeIsCNumber(nativePropertyInfo.type)) {
                [self setValue:remoteValue forKey:nativeKey];
            } else if (nativePropertyInfo.type & YYEncodingTypeObject) {
                NSString *nativeTypeClassName = [nativePropertyInfo.typeEncoding substringWithRange:NSMakeRange(2, nativePropertyInfo.typeEncoding.length - 3)];
                Class nativeType = NSClassFromString(nativeTypeClassName);
                // 类型一致
                if ([remoteValue isKindOfClass:nativeType]) {
                    // 类型一致直接赋值, 数组类型需要重写 setter方法
                    [self setValue:remoteValue forKey:nativeKey];
                } else {
                    //类型不一致
                    if (nativeType == [NSString class] && ![remoteValue isKindOfClass:nativeType]) {
                        // 容错 : nativie:NSString ; remote:NSNumber
                        NSAssert(NO, @"NSString is excepted for %@:%@ while %@ given", [self class], nativeKey, [remoteValue class]);
                        remoteValue = [NSString stringWithFormat:@"%@", remoteValue];
                        [self setValue:remoteValue forKey:nativeKey];
                    } else if (nativeType == [NSNumber class] && ![remoteValue isKindOfClass:nativeType]) {
                        // 容错 : native:NSNumber ; remote:NSString
                        NSAssert(NO, @"NSNumber is excepted for %@:%@ while %@ given", [self class], nativeKey, [remoteValue class]);
                        NSNumberFormatter *formatter = [NSNumberFormatter new];
                        remoteValue = [formatter numberFromString:remoteKey];
                        [self setValue:remoteValue forKey:nativeKey];
                    } else if ([remoteValue isKindOfClass:[NSDictionary class]]){
                        //  转为其他model
                        remoteValue = [nativeType modelWithDictionary:remoteValue];
                        [self setValue:remoteValue forKey:nativeKey];
                    } else {
                        // 暂时无法处理
                        if (nativeType) {
                            NSAssert(NO, @"Diff Class in Model:%@ ! Native type:%@ name:%@ ,Remote type:%@", [self class], nativeType, nativeKey, [remoteValue class]);
                        }
                    }
                }
            }
        }
    }
    return YES;
}

# pragma mark  - NSCoding 

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (BOOL)resolveInstanceMethod:(SEL)sel{
        
    if (self == [NSObject class]) {
        return NO;
    }
    
    NSString *methodName = NSStringFromSelector(sel);
    
    if ([methodName isEqualToString:@"encodeWithCoder:"]) {
        NSLog(@"Class:%@ add Selector 「encodeWithCoder:」 with IMP 「modelEncodeWithCoder:」 ",[self class]);
        Method modelEncodeMethod = class_getInstanceMethod(self, @selector(modelEncodeWithCoder:));
        class_addMethod(self, @selector(encodeWithCoder:), method_getImplementation(modelEncodeMethod), method_getTypeEncoding(modelEncodeMethod));
        return YES;
    } else if ([methodName isEqualToString:@"initWithCoder:"]) {
        NSLog(@"Class:%@ add Selector「initWithCoder:」 with IMP 「modelInitWithCoder:」",[self class]);
        Method modelDecodeMethod = class_getInstanceMethod(self, @selector(modelInitWithCoder:));
        class_addMethod(self, @selector(initWithCoder:), method_getImplementation(modelDecodeMethod), method_getTypeEncoding(modelDecodeMethod));
        return YES;
    }
    
    return [[[self class] superclass] resolveInstanceMethod:sel];
}
#pragma clang diagnostic pop

- (void)modelEncodeWithCoder:(NSCoder *)aCoder
{
    if (!aCoder) return;
    if (self == (id)kCFNull) {
        [((id<NSCoding>)self)encodeWithCoder:aCoder];
        return;
    }
    
    NSDictionary *writablePropertyKeyPairs = [[self class] _ls_writablePropertyKeys];
    for (NSString *propertyName in writablePropertyKeyPairs) {
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) {
            [aCoder encodeObject:propertyValue forKey:[self _ls_codingKeyWithPropertyName:propertyName]];
        }
    };
    return ;
}

- (instancetype)modelInitWithCoder:(NSCoder *)aDecoder
{
    if (!aDecoder) return self;
    if (self == (id)kCFNull) {
        return self;
    }
    
    NSDictionary *writablePropertyKeyPairs = [[self class] _ls_writablePropertyKeys];
    for (NSString *propertyName in writablePropertyKeyPairs) {
        id propertyValue = [aDecoder decodeObjectForKey:[self _ls_codingKeyWithPropertyName:propertyName]];
        [self setValue:propertyValue forKey:propertyName];
    };
    return self;
}

#pragma mark - Private Methods

+ (NSDictionary *)_ls_dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

+ (NSMutableDictionary *)_ls_writablePropertiyInfos{
    NSMutableDictionary *keyPairs = [NSMutableDictionary dictionary];
    
    YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:[self class]];
    [self addWritablePropertiesFromDictionary:classInfo.propertyInfos toDictionary:keyPairs];
    
    BOOL stop = NO;
    YYClassInfo *superClassInfo = classInfo.superClassInfo;
    while (!stop && [superClassInfo.cls isSubclassOfClass:[NSObject class]]) {
        [self addWritablePropertiesFromDictionary:superClassInfo.propertyInfos toDictionary:keyPairs];
        stop = superClassInfo.cls == [NSObject class];
        superClassInfo = superClassInfo.superClassInfo;
    }

    return keyPairs;
}

+ (void)addWritablePropertiesFromDictionary:(NSDictionary *)dictionary toDictionary:(NSMutableDictionary *)mutableDictionary
{
    for (NSString *key in [dictionary allKeys]) {
        YYClassPropertyInfo *propertyInfo = dictionary[key];
        if ([propertyInfo isKindOfClass:[YYClassPropertyInfo class]]) {
            if (!(propertyInfo.type & YYEncodingTypePropertyReadonly)) {
                [mutableDictionary setValue:propertyInfo forKey:key];
            }
        }
    }
}

+ (NSMutableDictionary *)_ls_writablePropertyKeys {
    NSMutableDictionary *keyPairs = [NSMutableDictionary dictionary];
    [self _ls_enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL *stop) {
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
                NSAssert5(NO, @"LSModel的子类的读写属性只支持以下几种类型：%@，%@，%@，%@，%@", @"NSString", @"NSNumber", @"BOOL", @"LSModel的子类", @"LSModel的子类的数组");
            }
            [keyPairs setObject:classString forKey:key];
        }
    }];
    
    return keyPairs;
}

+ (void)_ls_enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block
{
    Class cls = self;
    BOOL stop = NO;
    
    while (!stop && [cls isSubclassOfClass:[NSObject class]] && cls != [NSObject class]) {
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

- (NSString *)_ls_codingKeyWithPropertyName:(NSString *)name
{
    return [NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]), name];
}

@end

@implementation NSArray (LSModel)

+ (NSArray *)modelArrayWithClass:(Class)cls dataSource:(NSArray *)data
{
    return [self modelArrayWithClass:cls dataSource:data discrepantKeys:nil];
}

+ (NSArray *)modelArrayWithClass:(Class)cls dataSource:(NSArray *)data discrepantKeys:(NSDictionary *)discrepantKeys
{
    if (![data isKindOfClass:[NSArray class]]) {
        NSLog(@"load array property error, data is not array: %@", data);
        return nil;
    }
    
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *dict in data) {
        id model = [cls modelWithDictionary:dict discrepantKeys:discrepantKeys];
        [objects addObject:model];
    }
    
    return objects;
}

@end
