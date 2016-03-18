//
//  NSNumber+LS.h
//  LSFoundation
//
//  Created by liulihui on 15/9/24.
//  Copyright © 2015年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (LS)

- (NSString *)priceValue;

/**
 *  经纬度值，返回6位
 *
 *  @return 6位小数字符串
 */
- (NSString *)locationValue;

- (BOOL)isEqualToNumberSafe:(NSNumber *)number;

@end
