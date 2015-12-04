//
//  NSObject+LSValueCheck.h
//  LSFoundation
//
//  Created by liulihui on 14/12/24.
//  Copyright (c) 2014年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LSValueCheck)

- (BOOL)isValidateObject:(id)object;
+ (id)checkValue:(id)value defaultValue:(id)defaultValue;
- (id)defaultValue:(id)value;

@end
