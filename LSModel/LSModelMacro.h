//
//  LSModelMacro.h
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/5.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#ifndef LSModelMacro_h
#define LSModelMacro_h

#pragma mark 以下宏定义为了少手写点代码，自行选择使用

/**
 *  创建类型property的宏定义
 *
 *  @param __NAME__         需要创建的变量名
 *  @param __TYPE__         需要创建的变量类型名
 *  @param __ATTRIBUTE__    需要创建的变量属性修饰符
 *
 *  @return
 */
#define CREATE_PROPERTY(__NAME__, __TYPE__, __ATTRIBUTE__)\
@property (nonatomic, __ATTRIBUTE__) __TYPE__ __NAME__;

/**
 *  创建BOOL类型property的宏定义
 *
 *  @param __NAME__ 需要创建的变量名
 *
 *  @return
 */
#define CREATE_BOOL_PROPERTY(__NAME__)\
CREATE_PROPERTY(__NAME__, BOOL, assign)

/**Ô
 *  创建NSNumber类型property的宏定义
 *
 *  @param __NAME__ 需要创建的变量名
 *
 *  @return
 */
#define CREATE_NUMBER_PROPERTY(__NAME__)\
CREATE_PROPERTY(__NAME__, NSNumber *, strong)

/**
 *  创建string类型property的宏定义
 *
 *  @param __NAME__ 需要创建的变量名
 *
 *  @return
 */
#define CREATE_STRING_PROPERTY(__NAME__)\
CREATE_PROPERTY(__NAME__, NSString *, copy)

/**
 *  创建array类型property的宏定义
 *
 *  @param __NAME__ 需要创建的变量名
 *
 *  @return
 */
#define CREATE_ARRAY_PROPERTY(__NAME__)\
CREATE_PROPERTY(__NAME__, NSArray *, copy)

/**
 *  创建对象类型property的宏定义
 *
 *  @param __TYPE__ 需要创建的对象类型
 *  @param __NAME__ 需要创建的变量名
 *
 *  @return
 */
#define CREATE_OBJECT_PROPERTY(__TYPE__, __NAME__)\
CREATE_PROPERTY(__NAME__, __TYPE__ *, strong)

/**
 *  针对model中得对象类型的变量，重写setter方法的宏定义
 *  如果有什么特殊处理请自行重写setter
 *
 *  @param __TYPE__     变量的类型
 *  @param __NAME__     变量名
 *  @param __FUN_NAME__ 变量对应的方法名
 *  示例：SETPROPERTY(FBBlock, block , Block)
 *
 *  @return 变量对应的setter方法
 */
#define SETPROPERTY(__TYPE__, __NAME__, __FUN_NAME__)   \
- (void)set##__FUN_NAME__:(id)__NAME__ \
{ \
if ([__NAME__ isKindOfClass:[NSDictionary class]]) {   \
[_##__NAME__ loadPropertiesWithData:__NAME__];  \
} else if([__NAME__ isKindOfClass:[__TYPE__ class]]){   \
if (_##__NAME__ != __NAME__){   \
_##__NAME__ = __NAME__; \
}   \
} else if (!__NAME__){   \
_##__NAME__ = __NAME__; \
} \
}

/**
 *  针对model中得数组类型的变量(数组中得对象类型为自定义对象类型)，重写setter方法的宏定义
 *  如果有什么特殊处理请自行重写setter
 *
 *  @param __TYPE__     数组中变量的类型
 *  @param __NAME__     变量名
 *  @param __FUN_NAME__ 变量对应的方法名
 *  示例：SETARRAYPROPERTY(FBCommunity, communities, Communities)
 *
 *  @return 变量对应的setter方法
 */
#define SETARRAYPROPERTY(__TYPE__, __NAME__, __FUN_NAME__)  \
- (void)set##__FUN_NAME__:(NSArray *)__NAME__   \
{   \
if (![__NAME__ isKindOfClass:[NSArray class]]) {   \
if (!__NAME__){   \
_##__NAME__ = __NAME__; \
} \
return; \
}   \
BOOL realAssign = NO;   \
if (__NAME__.count > 0 && [__NAME__[0] isKindOfClass:[__TYPE__ class]]) {   \
realAssign = YES;   \
}   \
if (!realAssign) {   \
_##__NAME__ = [self loadArrayPropertyWithDataSource:__NAME__ requireModel:@#__TYPE__];   \
} else {   \
if (_##__NAME__ != __NAME__){   \
_##__NAME__ = __NAME__;   \
}   \
}   \
}

#define MODEL_CODING_IMPLEMENTATION \
- (void)encodeWithCoder:(NSCoder *)aCoder \
{ \
    return [self modelEncodeWithCoder:aCoder]; \
} \
 \
- (instancetype)initWithCoder:(NSCoder *)aDecoder \
{ \
    return [self modelInitWithCoder:aDecoder]; \
} 

#endif /* LSModelMacro_h */
