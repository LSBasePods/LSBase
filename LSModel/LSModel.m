//
//  LSModel.m
//  LSFoundation
//
//  Created by wysasun on 15/3/12.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "LSModel.h"
NSString * const kLSModelPropertyDefaultValue = @"";
NSInteger const kLSModelNumberPropertyDefaultValue = NSIntegerMin;

static BOOL needTypeCheckForce = YES;

@implementation LSModel
/**
 *  服务器返回的属性与本地属性不对等的列表，以 服务器属性名:本地属性名 为一个单元
 *  如果服务器与本地属性相同不需要加入此列表
 *
 *  子类中如果存在属性名与服务器不一致的情况，需要重写本方法
 *
 *  @return 差异属性名称列表
 */
+ (NSDictionary *)discrepantKeys
{
    return @{};
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)loadPropertiesWithData:(id)data
{
    [self loadPropertiesWithData:data discrepantKeys:[[self class] discrepantKeys]];
}

- (void)loadPropertiesWithData:(id)data discrepantKeys:(NSDictionary *)discrepantKeys
{
    if (![data isKindOfClass:[NSDictionary class]] && ![data isKindOfClass:[LSModel class]]) {
        NSLog(@"load property error, data is not dictionary or LSModel: %@", data);
        return;
    }
    
    NSDictionary *diffDictionary = [self reverseDictionary:discrepantKeys];
    NSDictionary *writablePropertyKeyPairs = [[self class] writablePropertyKeys];
    for (NSString *propertyName in writablePropertyKeyPairs) {
        NSString *oldPropertyName = diffDictionary[propertyName]?diffDictionary[propertyName]:propertyName;
        id value = [data valueForKey:oldPropertyName];
        if ([value isKindOfClass:[NSNull class]]) {
            continue;
        }
        if (value) {
            NSString *propertyType = writablePropertyKeyPairs[propertyName];
            Class class = NSClassFromString(propertyType);
            if (class == [NSString class] && ![value isKindOfClass:class]) {
                if (needTypeCheckForce) {
                    NSAssert(NO, @"NSString is excepted for %@:%@ while %@ given", [self class], propertyName, [value class]);
                }
                value = [NSString stringWithFormat:@"%@", value];
            } else if (class == [NSNumber class] && ![value isKindOfClass:class]) {
                if (needTypeCheckForce) {
                    NSAssert(NO, @"NSNumber is excepted for %@:%@ while %@ given", [self class], propertyName, [value class]);
                }
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                value = [formatter numberFromString:value];
            } else if ([propertyType isEqualToString:@"BOOL"]) {
                value = @([value boolValue]);
            }
            
            [self setValue:value forKey:propertyName];
        }
    }
}

/**
 *  字典key-value反转
 *  让discrepantKeys的结构不变
 *
 *  @param dictionary 需要反转的原字典
 *
 *  @return 反转后的字典
 */
- (NSDictionary *)reverseDictionary:(NSDictionary *)dictionary
{
    NSArray *keys = dictionary.allKeys;
    NSArray *values = [dictionary objectsForKeys:keys notFoundMarker:[NSNull null]];
    NSDictionary *reverseDictionary = [NSDictionary dictionaryWithObjects:keys forKeys:values];
    return reverseDictionary;
}

#pragma clang diagnostic pop
- (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)modelClass
{
    return [self loadArrayPropertyWithDataSource:data requireModel:modelClass discrepantKeys:nil];
}

- (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)modelClass discrepantKeys:(NSDictionary *)discrepantKeys
{
    return [[self class] loadArrayPropertyWithDataSource:data requireModel:modelClass discrepantKeys:discrepantKeys];
}



+ (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)modelClass
{
    return [self loadArrayPropertyWithDataSource:data requireModel:modelClass discrepantKeys:nil];
}

+ (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)modelClass discrepantKeys:(NSDictionary *)discrepantKeys
{
    if (![data isKindOfClass:[NSArray class]]) {
        NSLog(@"load array property error, data is not array: %@", data);
        return nil;
    }
    
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *dict in data) {
        LSModel *model = [[NSClassFromString(modelClass) alloc] init];
        if (![model isKindOfClass:[LSModel class]]) {
            NSLog(@"load array property error, requireModel [%@] is not subclass of BIFModel", model);
            return nil;
        }
        
        if (discrepantKeys) {
            [model loadPropertiesWithData:dict discrepantKeys:discrepantKeys];
        } else {
            [model loadPropertiesWithData:dict];
        }
        [objects addObject:model];
    }
    
    return objects;
}

#pragma mark - init

- (instancetype)initWithData:(NSDictionary *)data
{
    if (self = [super init]) {
        [self setupAllValues];
        [self loadPropertiesWithData:data];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupAllValues];
    }
    
    return self;
}

#pragma mark - reset values

- (void)setupAllValues
{
    [self setupAllValuesInClass:[self class]];
}

- (void)setupAllValuesInClass:(Class)class
{
    if ([class superclass] != [LSModel class]) {
        [self setupAllValuesInClass:[class superclass]];
    }
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    for (int i = 0; i < count; ++ i) {
        NSString *propertyClassName = [[NSString alloc] initWithCString:property_getAttributes(properties[i])
                                                               encoding:NSUTF8StringEncoding];
        propertyClassName = [self classNameFromType:propertyClassName];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(properties[i])
                                                          encoding:NSUTF8StringEncoding];
        
        if (!propertyClassName) {
            continue;
        }
        
        if ([propertyClassName isEqualToString:@"NSNumber"]) {
            [self setValue:@(kLSModelNumberPropertyDefaultValue) forKey:propertyName];
            continue;
        }
        
        if ([propertyClassName isEqualToString:@"NSString"]) {
            [self setValue:kLSModelPropertyDefaultValue forKey:propertyName];
            continue;
        }
        
        if ([NSClassFromString(propertyClassName) isSubclassOfClass:[LSModel class]]) {
            LSModel *model = [[NSClassFromString(propertyClassName) alloc] init];
            [self setValue:model forKey:propertyName];
        }
    }
    free(properties);
}

- (NSString *)classNameFromType:(NSString *)propertyType
{
    NSArray *array = [propertyType componentsSeparatedByString:@"\""];
    if ([array count] == 3) {
        return array[1];
    } else {
        return nil;
    }
}

+ (void)setNeedToCheckDataTypeForce:(BOOL)needCheck
{
    needTypeCheckForce = needCheck;
}

#pragma mark - NSCoding methods 方便子类（反）序列化
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"encode object [%@] %@", [self class], self);
}

@end
