//
//  NSObject+LSModel.h
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/4.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSModelMacro.h"

@protocol LSModel <NSObject>

/**
 *  服务器返回的属性与本地属性不对等的列表，以 本地属性名:服务器属性名 为一个单元
 *  如果服务器与本地属性相同不需要加入此列表
 *
 *  @return 差异属性名称列表
 */
+ (NSDictionary *)discrepantKeys;

@end

@interface NSObject (LSModel)

#pragma mark Model Factory

+ (instancetype)modelWithJSON:(id)json;
+ (instancetype)modelWithJSON:(id)json discrepantKeys:(NSDictionary *)discrepantKeys;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary discrepantKeys:(NSDictionary *)discrepantKeys;

+ (instancetype)modelWithOtherObject:(id)object;
+ (instancetype)modelWithOtherObject:(id)object discrepantKeys:(NSDictionary *)discrepantKeys;

- (BOOL)modelSetWithJSON:(id)json;
- (BOOL)modelSetWithJSON:(id)json discrepantKeys:(NSDictionary *)discrepantKeys;

- (BOOL)modelSetWithDictionary:(NSDictionary *)dic;
- (BOOL)modelSetWithDictionary:(NSDictionary *)dic discrepantKeys:(NSDictionary *)discrepantKeys;

- (BOOL)modelSetWithOtherObject:(id)object;
- (BOOL)modelSetWithOtherObject:(id)object discrepantKeys:(NSDictionary *)discrepantKeys;

# pragma mark Encode
- (void)modelEncodeWithCoder:(NSCoder *)aCoder;
- (id)modelInitWithCoder:(NSCoder *)aDecoder;

@end

@interface NSArray (LSModel)

+ (NSArray *)modelArrayWithClass:(Class)cls dataSource:(NSArray *)data;
+ (NSArray *)modelArrayWithClass:(Class)cls dataSource:(NSArray *)data discrepantKeys:(NSDictionary *)discrepantKeys;

@end