//
//  LSModelMappingProtocol.h
//  LSFoundation
//
//  Created by liulihui on 15/6/15.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+LSValueCheck.h"
@protocol LSModelMappingProtocol <NSObject>

@optional
+ (id)modelMappingFromObject:(id)object;

@end
