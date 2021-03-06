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
        id remoteValue = [dic valueForKey:nativeKey];
        if (!remoteValue) {
            NSString *remoteKey = discrepantKeys[nativeKey] ? : nativeKey;
            remoteValue = [dic valueForKey:remoteKey];
        }
        if ([remoteValue isEqual:[NSNull null]]) {
            continue;
        }
        if (remoteValue) {
            // 基本类型数字处理
            if (LSEncodingTypeIsCNumber(nativePropertyInfo.type)) {
                if ([remoteValue isKindOfClass:[NSNumber class]]) {
                    [self setValue:remoteValue forKey:nativeKey];
                } else {
                    NSNumber *number = [NSNumber numberWithDouble:[NSString stringWithFormat:@"%@",remoteValue].doubleValue];
                    [self setValue:number forKey:nativeKey];
                }            } else if (nativePropertyInfo.type & YYEncodingTypeObject) {
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
                        NSLog(@"NSString is excepted for %@:%@ while %@ given", [self class], nativeKey, [remoteValue class]);
                        remoteValue = [NSString stringWithFormat:@"%@", remoteValue];
                        [self setValue:remoteValue forKey:nativeKey];
                    } else if (nativeType == [NSNumber class] && ![remoteValue isKindOfClass:nativeType]) {
                        // 容错 : native:NSNumber ; remote:NSString
                        NSLog(@"NSNumber is excepted for %@:%@ while %@ given", [self class], nativeKey, [remoteValue class]);
                        NSNumberFormatter *formatter = [NSNumberFormatter new];
                        remoteValue = [formatter numberFromString:remoteValue];
                        [self setValue:remoteValue forKey:nativeKey];
                    } else if ([remoteValue isKindOfClass:[NSDictionary class]]){
                        //  转为其他model
                        remoteValue = [nativeType modelWithDictionary:remoteValue];
                        [self setValue:remoteValue forKey:nativeKey];
                    } else {
                        // 暂时无法处理
                        if (nativeType) {
                            NSLog(@"Diff Class in Model:%@ ! Native type:%@ name:%@ ,Remote type:%@", [self class], nativeType, nativeKey, [remoteValue class]);
                        } else {
                            if ([nativeTypeClassName hasPrefix:@"<"] && [nativeTypeClassName hasSuffix:@">"]) {
                                NSString *nativeDelegateProtocolName = [nativeTypeClassName substringWithRange:NSMakeRange(1, nativeTypeClassName.length - 2)];
                                Protocol *nativeDelegateProtocol = NSProtocolFromString(nativeDelegateProtocolName);
                                if ([remoteValue conformsToProtocol:nativeDelegateProtocol]) {
                                    [self setValue:remoteValue forKey:nativeKey];
                                }
                            }
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
    NSDictionary *dic = [NSDictionary modelJSONDictionaryWithModel:object];
    return [self modelSetWithDictionary:dic discrepantKeys:discrepantKeys];
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
    
    NSDictionary *writablePropertiyInfos = [[self class] _ls_writablePropertiyInfos];
    for (NSString *propertyName in writablePropertiyInfos.allKeys) {
        YYClassPropertyInfo *propertyInfo = writablePropertiyInfos[propertyName];
        if (propertyInfo.type & YYEncodingTypeObject) {
            if (propertyInfo.typeEncoding.length < 3) {
                continue;
            }
            NSString *nativeTypeClassName = [propertyInfo.typeEncoding substringWithRange:NSMakeRange(2, propertyInfo.typeEncoding.length - 3)];
            Class nativeType = NSClassFromString(nativeTypeClassName);
            if (!nativeType || !propertyName) {
                continue;
            }
        }
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
    
    NSDictionary *writablePropertiyInfos = [[self class] _ls_writablePropertiyInfos];
    for (NSString *propertyName in writablePropertiyInfos.allKeys) {
        id propertyValue = [aDecoder decodeObjectForKey:[self _ls_codingKeyWithPropertyName:propertyName]];
        if (propertyValue) {
            [self setValue:propertyValue forKey:propertyName];
        }
    };
    return self;
}

- (NSDictionary *)convertToJSONDic
{
    return [NSDictionary modelJSONDictionaryWithModel:self];
}

- (NSData *)convertToJSONData
{
    NSDictionary *jsonDic = [self convertToJSONDic];
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
//        NSLog(@"Successfully serialized the dictionary into data.");
    }
    else if ([jsonData length] == 0 &&
             error == nil){
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@", error);
    }
    
    return jsonData;
}

- (NSString *)convertToJSONStr
{
    //NSData转换为String
    return [[NSString alloc] initWithData:[self convertToJSONData] encoding:NSUTF8StringEncoding];
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
    [self _ls_addWritablePropertiesFromDictionary:classInfo.propertyInfos toDictionary:keyPairs];
    
    BOOL stop = NO;
    YYClassInfo *superClassInfo = classInfo.superClassInfo;
    while (!stop && [superClassInfo.cls isSubclassOfClass:[NSObject class]] /*&& superClassInfo.cls != [NSObject class]*/) {
        [self _ls_addWritablePropertiesFromDictionary:superClassInfo.propertyInfos toDictionary:keyPairs];
        stop = superClassInfo.cls == [NSObject class];
        superClassInfo = superClassInfo.superClassInfo;
    }

    return keyPairs;
}

+ (void)_ls_addWritablePropertiesFromDictionary:(NSDictionary *)dictionary toDictionary:(NSMutableDictionary *)mutableDictionary
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

@implementation NSDictionary (LSModel)

+ (NSDictionary *)modelJSONDictionaryWithModel:(id)model;
{
    if ([model class] == [NSObject class]) {
        return nil;
    }
    
    NSMutableDictionary *modelDic = [NSMutableDictionary dictionary];
    YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:[model class]];
    // 获取所有属性
    NSMutableDictionary *propertyInfos = [classInfo.propertyInfos mutableCopy];
    YYClassInfo *superClassInfo = classInfo.superClassInfo ;
    while (superClassInfo.cls != [NSObject class]) {
        [propertyInfos addEntriesFromDictionary:superClassInfo.propertyInfos];
        superClassInfo = superClassInfo.superClassInfo;
    }
    
    for (NSString *key in propertyInfos.allKeys) {
        if ([key isEqualToString:@"debugDescription"] ||
            [key isEqualToString:@"description"]||
            [key isEqualToString:@"hash"]) {
            continue;
        }
        YYClassPropertyInfo *propertyInfo = propertyInfos[key];
        id remoteValue = [model valueForKey:key];
        if (!remoteValue) {
            continue;
        }
        if (LSEncodingTypeIsCNumber(propertyInfo.type) || [remoteValue isKindOfClass:[NSString class]] || [remoteValue isKindOfClass:[NSNumber class]]) {
            [modelDic setValue:remoteValue forKey:key];
        } else if (propertyInfo.type & YYEncodingTypeObject){
            // 子属性的
            if (propertyInfo.typeEncoding.length < 3) {
                continue;
            }
            NSString *className = [propertyInfo.typeEncoding substringWithRange:NSMakeRange(2, propertyInfo.typeEncoding.length - 3)];
            Class class = NSClassFromString(className);
            if ([class isSubclassOfClass:[NSArray class]]) {
                NSMutableArray *dicArray = [NSMutableArray array];
                for (NSObject *itemModel in (NSArray *)remoteValue) {
                    [dicArray addObject:[NSDictionary modelJSONDictionaryWithModel:itemModel]];
                }
                if (remoteValue) {
                    [modelDic setValue:[dicArray copy] forKey:key];
                }
            } else {
                NSDictionary *subDic = [NSDictionary modelJSONDictionaryWithModel:remoteValue];
                if (class && class != [NSObject class] && subDic.allKeys.count) {
                    [modelDic setValue:subDic forKey:key];
                }
            }
        }
    }
    
    return [modelDic copy];
}

@end
