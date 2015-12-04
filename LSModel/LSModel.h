//
//  LSModel.h
//  LSFoundation
//
//  Created by wysasun on 15/3/12.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "LSFObject.h"
#import "LSModelPropertyMacro.h"
#import "LSModelMappingProtocol.h"

@protocol LSModel<LSFObject>
/**
 *  服务器返回的属性与本地属性不对等的列表，以 服务器属性名:本地属性名 为一个单元
 *  如果服务器与本地属性相同不需要加入此列表
 *
 *  @return 差异属性名称列表
 */
+ (NSDictionary *)discrepantKeys;
@end

/**
 *  服务器返回数据映射的数据模型
 *  服务器返回的是json格式，由json的结构可知
 *  该类型中的成员变量都应转换成：NSString、LSFModel、NSArray三种类型（整型、浮点型数据均用NSString表示）
 */
@interface LSModel : LSFObject<LSModel,NSCoding>
- (instancetype)init;
- (instancetype)initWithData:(NSDictionary *)data;

/**
 *  是否严格显示类型转换时候对象属性的基本类型
 *  如果设置为YES，则数字和字符串不能互相赋值
 *
 *  @param needLimit 是否需要严格限制，默认为YES
 */
+ (void)setNeedToCheckDataTypeForce:(BOOL)needCheck;

/**
 *  字典转object
 *
 *  @param data 需要转换的数据,NSDictionary 或者 LSModel
 */
- (void)loadPropertiesWithData:(id)data;

/**
 *  字典转object
 *
 *  @param data 需要转换的数据,NSDictionary 或者 LSModel
 *  @param discrepantKeys 如+ (NSDictionary *)discrepantKeys
 */
- (void)loadPropertiesWithData:(id)data discrepantKeys:(NSDictionary *)discrepantKeys;

/**
 *  array 转 objects
 *
 *  @param data  数据源
 *  @param model 数据模型名
 *
 *  @return 转换后的的数据模型数组
 */
+ (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)model;
- (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)modelClass;

/**
 *  array 转 objects
 *
 *  @param data  数据源
 *  @param model 数据模型名
 *  @param discrepantKeys 如+ (NSDictionary *)discrepantKeys
 *
 *  @return 转换后的的数据模型数组
 */
+ (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)model discrepantKeys:(NSDictionary *)discrepantKeys;
- (NSArray *)loadArrayPropertyWithDataSource:(NSArray *)data requireModel:(NSString *)modelClass discrepantKeys:(NSDictionary *)discrepantKeys;
@end
