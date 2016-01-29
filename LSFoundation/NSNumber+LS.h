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

- (BOOL)isEqualToNumberSafe:(NSNumber *)number;

@end
