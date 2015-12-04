//
//  NSString+URLQueryResolver.h
//  LSFoundation
//
//  Created by 白开水_孙 on 15/5/25.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLQueryResolver)
- (NSDictionary *)QR_queryItems;
- (NSString *)QR_urlDecode;
- (NSString *)QR_urlEncode;
@end
