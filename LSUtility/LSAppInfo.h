//
//  LSAppInfo.h
//  LSFoundation
//
//  Created by liulihui on 14/12/31.
//  Copyright (c) 2014年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAppInfo : NSObject


//appBundle信息
+ (NSString *)appBundle;
//app 显示名称
+ (NSString *)appName;
//app版本
+ (NSString *)appVersion;
//appBuild版本
+ (NSString *)appBuild;
//app渠道信息
+ (NSString *)appChannelID;


@end
