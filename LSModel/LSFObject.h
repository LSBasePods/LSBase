//
//  LSFObject.h
//  LSFoundation
//
//  Created by wysasun on 15/3/12.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@protocol LSFObject <NSObject>

/**
 *  用字典来描述这个类，字典中包含类中的所有属性，以 属性名:属性值 为一个单位。
 *
 *  @return 代表这个类的字典。
 */
- (NSMutableDictionary *)dictionaryRepresentation NS_DEPRECATED_IOS(7_0, 7_0);/*名字不太好记，换成detailInfo*/

- (NSMutableDictionary *)detailInfo;
@optional

/**
 *  方法重组，需要的情况下实现
 */
+ (void)swizzleSelector;
@end

@interface LSFObject : NSObject<LSFObject>
/**
 *  返回所有可写的属性集合
 *
 *  @return 所有可写的属性集合
 */
+ (NSMutableDictionary *)writablePropertyKeys;

/**
 *  返回所有的属性集合
 *
 *  @return 所有的属性集合
 */
+ (NSSet *)allPropertyKeys;

/**
 *  类型遍历变量所需的迭代器
 *  一般情况下无需直接调用，留在这里如有必要在子类中重载
 *
 *  @param block 每个迭代执行的操作
 */
+ (void)enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block;
@end
