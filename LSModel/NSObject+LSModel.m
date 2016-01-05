//
//  NSObject+LSModel.m
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/4.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "NSObject+LSModel.h"
#import <objc/runtime.h>

@implementation NSObject (LSModel)

#pragma mark - Public Methods
+ (instancetype)modelWithJSON:(id)json
{
    NSDictionary *discrepantKeys = nil;
    if ([self conformsToProtocol:@protocol(LSModel)] && [self instancesRespondToSelector:@selector(discrepantKeys)]) {
        discrepantKeys = [((id<LSModel>)self) discrepantKeys];
    }
    return [self modelWithJSON:json discrepantKeys:0];
}

+ (instancetype)modelWithJSON:(id)json discrepantKeys:(NSDictionary *)discrepantKeys
{
    NSDictionary *dic = [self _ls_dictionaryWithJSON:json];
    return [self modelWithDictionary:dic discrepantKeys:discrepantKeys];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *discrepantKeys = nil;
    if ([self conformsToProtocol:@protocol(LSModel)] && [self instancesRespondToSelector:@selector(discrepantKeys)]) {
        discrepantKeys = [((id<LSModel>)self) discrepantKeys];
    }
    return [self modelWithDictionary:dictionary discrepantKeys:0];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary discrepantKeys:(NSDictionary *)discrepantKeys
{
    if (!dictionary || dictionary == (id)kCFNull) return nil;
    if (![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    
    Class cls = [self class];
    
    //TODO Cached Class
    
    NSObject *one = [cls new];
    if ([one modelSetWithDictionary:dictionary discrepantKeys:discrepantKeys]) {
        return one;
    }
    
    return nil;
}

+ (instancetype)modelWithOtherObject:(id)object
{
    NSDictionary *discrepantKeys = nil;
    if ([self conformsToProtocol:@protocol(LSModel)] && [self instancesRespondToSelector:@selector(discrepantKeys)]) {
        discrepantKeys = [((id<LSModel>)self) discrepantKeys];
    }
    return [self modelWithOtherObject:object discrepantKeys:discrepantKeys];
}

+ (instancetype)modelWithOtherObject:(id)object discrepantKeys:(NSDictionary *)discrepantKeys
{
    Class cls = [self class];
    
    //TODO Cached Class
    
    NSObject *one = [cls new];
    if ([one modelSetWithOtherObject:object discrepantKeys:discrepantKeys]) {
        return one;
    }

    return 0;
}

- (BOOL)modelSetWithJSON:(id)json
{
    NSDictionary *discrepantKeys = nil;
    if ([self conformsToProtocol:@protocol(LSModel)] && [[self class] instancesRespondToSelector:@selector(discrepantKeys)]) {
        discrepantKeys = [((id<LSModel>)self) discrepantKeys];
    }
    return [self modelSetWithJSON:json discrepantKeys:discrepantKeys];
}

- (BOOL)modelSetWithJSON:(id)json discrepantKeys:(NSDictionary *)discrepantKeys
{
    NSDictionary *dic = [[self class] _ls_dictionaryWithJSON:json];
    return [self modelSetWithDictionary:dic discrepantKeys:discrepantKeys];
}

- (BOOL)modelSetWithDictionary:(NSDictionary *)dic
{
    NSDictionary *discrepantKeys = nil;
    if ([self conformsToProtocol:@protocol(LSModel)] && [[self class] instancesRespondToSelector:@selector(discrepantKeys)]) {
        discrepantKeys = [((id<LSModel>)self) discrepantKeys];
    }
    return [self modelSetWithDictionary:dic discrepantKeys:discrepantKeys];
}

- (BOOL)modelSetWithDictionary:(NSDictionary *)dic discrepantKeys:(NSDictionary *)discrepantKeys
{
    if (!dic || dic == (id)kCFNull) return NO;
    if (![dic isKindOfClass:[NSDictionary class]]) return NO;
    
    NSDictionary *writablePropertyKeyPairs = [[self class] _ls_writablePropertyKeys];
    for (NSString *nativePropertyName in writablePropertyKeyPairs) {
        
        NSString *remotePropertyName = discrepantKeys[nativePropertyName] ? discrepantKeys[nativePropertyName] : nativePropertyName;
        id remotePropertyValue = [dic valueForKey:remotePropertyName];
        if ([remotePropertyValue isKindOfClass:[NSNull class]]) {
            continue;
        }
        if (remotePropertyValue) {
            NSString *propertyType = writablePropertyKeyPairs[nativePropertyName];
            Class class = NSClassFromString(propertyType);
            
            if ([class isSubclassOfClass:[NSString class]] || [class isSubclassOfClass:[NSNumber class]]){
                // JSON基本类型
                if (class == [NSString class] && ![remotePropertyValue isKindOfClass:class]) {
                    // 容错 : nativie:NSString ; remote:NSNumber
                    NSAssert(NO, @"NSString is excepted for %@:%@ while %@ given", [self class], nativePropertyName, [remotePropertyValue class]);
                    remotePropertyValue = [NSString stringWithFormat:@"%@", remotePropertyValue];
                } else if (class == [NSNumber class] && ![remotePropertyValue isKindOfClass:class]) {
                    // 容错 : native:NSNumber ; remote:NSString
                    NSAssert(NO, @"NSNumber is excepted for %@:%@ while %@ given", [self class], nativePropertyName, [remotePropertyValue class]);
                    NSNumberFormatter *formatter = [NSNumberFormatter new];
                    remotePropertyValue = [formatter numberFromString:remotePropertyValue];
                }
            } else if ([propertyType isEqualToString:@"BOOL"]) {
                // 转为BOOL类型
                remotePropertyValue = @([remotePropertyValue boolValue]);
            } else if ([class isSubclassOfClass:[NSArray class]]) {
                //  TODO 转为数组
            } else {
                //  转为其他model
                remotePropertyValue = [class modelWithDictionary:remotePropertyValue];
            }
            
            [self setValue:remotePropertyValue forKey:nativePropertyName];
        }
    }
    
    return YES;
}

- (BOOL)modelSetWithOtherObject:(id)object
{
    NSDictionary *discrepantKeys = nil;
    if ([self conformsToProtocol:@protocol(LSModel)] && [[self class] instancesRespondToSelector:@selector(discrepantKeys)]) {
        discrepantKeys = [((id<LSModel>)self) discrepantKeys];
    }
    return [self modelSetWithOtherObject:object discrepantKeys:discrepantKeys];
}

- (BOOL)modelSetWithOtherObject:(id)object discrepantKeys:(NSDictionary *)discrepantKeys
{
    NSDictionary *writablePropertyKeyPairs = [[self class] _ls_writablePropertyKeys];
    for (NSString *nativePropertyName in writablePropertyKeyPairs) {
        
        NSString *remotePropertyName = discrepantKeys[nativePropertyName] ? discrepantKeys[nativePropertyName] : nativePropertyName;
        id remotePropertyValue = [object valueForKey:remotePropertyName];
        if ([remotePropertyValue isKindOfClass:[NSNull class]]) {
            continue;
        }
        if (remotePropertyValue) {
            NSString *propertyType = writablePropertyKeyPairs[nativePropertyName];
            Class class = NSClassFromString(propertyType);
            
            if ([class isSubclassOfClass:[NSString class]] || [class isSubclassOfClass:[NSNumber class]]){
                // JSON基本类型
                if (class == [NSString class] && ![remotePropertyValue isKindOfClass:class]) {
                    // 容错 : nativie:NSString ; remote:NSNumber
                    NSAssert(NO, @"NSString is excepted for %@:%@ while %@ given", [self class], nativePropertyName, [remotePropertyValue class]);
                    remotePropertyValue = [NSString stringWithFormat:@"%@", remotePropertyValue];
                } else if (class == [NSNumber class] && ![remotePropertyValue isKindOfClass:class]) {
                    // 容错 : native:NSNumber ; remote:NSString
                    NSAssert(NO, @"NSNumber is excepted for %@:%@ while %@ given", [self class], nativePropertyName, [remotePropertyValue class]);
                    NSNumberFormatter *formatter = [NSNumberFormatter new];
                    remotePropertyValue = [formatter numberFromString:remotePropertyValue];
                }
            } else if ([propertyType isEqualToString:@"BOOL"]) {
                // 转为BOOL类型
                remotePropertyValue = @([remotePropertyValue boolValue]);
            } else if ([class isSubclassOfClass:[NSArray class]]) {
                //  TODO 转为数组
            } else {
                //  转为其他model
                remotePropertyValue = [class modelWithOtherObject:remotePropertyValue];
            }
            
            [self setValue:remotePropertyValue forKey:nativePropertyName];
        }
    }
    
    return YES;}

- (id)modelToJSONObject
{
    return 0;
}

- (NSData *)modelToJSONData
{
    return 0;
}

- (NSString *)modelToJSONString
{
    return 0;
}

- (id)modelCopy
{
    return 0;
}

- (void)modelEncodeWithCoder:(NSCoder *)aCoder
{
    return ;
}

- (id)modelInitWithCoder:(NSCoder *)aDecoder
{
    return 0;
}

- (NSUInteger)modelHash
{
    return 0;
}

- (BOOL)modelIsEqual:(id)model
{
    return 0;
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

+ (NSMutableDictionary *)_ls_writablePropertyKeys {
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
                NSAssert5(NO, @"LSModel的子类的读写属性只支持以下几种类型：%@，%@，%@，%@，%@", @"NSString", @"NSNumber", @"BOOL", @"LSModel的子类", @"LSModel的子类的数组");
            }
            [keyPairs setObject:classString forKey:key];
        }
    }];
    
    return keyPairs;
}

+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block
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
