//
//  LSKeychain.h
//  LSFoundation
//
//  Created by liulihui on 14/12/8.
//  Copyright (c) 2014年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSKeychain : NSObject

+ (NSString *)bundleSeedID;

- (id)initWithService:(NSString *)service withGroup:(NSString *)group;
- (BOOL)insert:(NSString *)key data:(NSData *)data;
- (BOOL)update:(NSString *)key data:(NSData *)data;
- (BOOL)remove:(NSString *)key;
- (NSData *)find:(NSString *)key;

@end
