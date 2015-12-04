//
//  LSUDIDGenerator.h
//  LSFoundation
//
//  Created by liulihui on 14/12/8.
//  Copyright (c) 2014年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSUDIDGenerator : NSObject

@property (nonatomic, copy, readonly) NSString *udid;
@property (nonatomic, copy, readonly) NSString *appBundleName;

+ (id)sharedInstance;

@end
