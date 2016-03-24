//
//  NSString+URLQueryResolver.h
//  LSBaseExample
//
//  Created by liulihui on 16/3/24.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLQueryResolver)

- (NSDictionary *)QR_queryItems;
- (NSString *)QR_urlDecode;
- (NSString *)QR_urlEncode;

@end
