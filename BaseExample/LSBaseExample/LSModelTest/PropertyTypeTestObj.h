//
//  PropertyTypeTestObj.h
//  LSBaseExample
//
//  Created by Terry Zhang on 16/3/1.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyTypeTestObj : NSObject

@property (nonatomic, assign) BOOL boolType;

// signed Int
@property (nonatomic, assign) int8_t int8Type;
@property (nonatomic, assign) int16_t int16Type;
@property (nonatomic, assign) int32_t int32Type;
@property (nonatomic, assign) int64_t int64Type;

// unsigned Int
@property (nonatomic, assign) UInt8 unint8Type;
@property (nonatomic, assign) UInt16 uint16Type;
@property (nonatomic, assign) UInt32 uint32Type;
@property (nonatomic, assign) UInt64 uint64Type;

// float
@property (nonatomic, assign) float floatType;
@property (nonatomic, assign) double doubleType;
@property (nonatomic, assign) long double longDoubleType;

// oc type
@property (nonatomic, assign) NSInteger integerType;
@property (nonatomic, assign) NSUInteger uintegerType;
//@property (nonatomic, assign) CGFloat cgfloatType;
@property (nonatomic, strong) NSString *stringType;
@property (nonatomic, strong) NSNumber *numberType;
@property (nonatomic, strong) NSArray *arrayType;
@property (nonatomic, strong) NSDictionary *dictionaryType;

//INTw8_C(1)

@end
