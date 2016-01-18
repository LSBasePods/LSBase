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
 *  实现 数组属性 的Setter方法，以实现LSModel自动转化
 *  请在 implementation 内使用，不需要加括号
 *
 *  @param __TYPE__            数组中变量的类型
 *  @param __NAME__            属性名
 *  @param __SETTER_FUN_NAME__ 属性对应的 Setter 方法
 *
 *  示例：ARRAY_PROPERTY_SETTER(User, userList, setUserList)
 *
 *  @return
 */
#define ARRAY_PROPERTY_SETTER(__TYPE__, __NAME__, __SETTER_FUN_NAME__)  \
- (void)__SETTER_FUN_NAME__:(NSArray *)__NAME__   \
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
        _##__NAME__ = [NSArray modelArrayWithClass:[__TYPE__ class] dataSource:__NAME__];  \
    } else {   \
        if (_##__NAME__ != __NAME__){   \
            _##__NAME__ = __NAME__;   \
        }   \
    }   \
}
#endif /* LSModelMacro_h */
