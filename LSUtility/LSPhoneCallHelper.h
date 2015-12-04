//
//  LSPhoneCallHelper.h
//  LSCommonService
//
//  Created by 白开水_孙 on 15/4/29.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  拨打失败以后默认的接通时间
 *  any value less than 0
 */
extern CFAbsoluteTime const LSPHONECALLFAILEDTIME;

/**
 *  拨号完成的回调方法
 *
 *  @param CFAbsoluteTime 通话时间，如果通话时间小于0表示电话未拨出
 */
typedef void (^LKPhoneCallOverBlock) (CFAbsoluteTime time);

@interface LSPhoneCallHelper : NSObject
/**
 *  单例实例获取方法
 *
 *  @return 单例实例
 */
+ (instancetype)sharePhoneCallHelper;

/**
 *  检查设备是否支持电话通讯
 *
 *  @return 设备是否支持电话通讯
 */
- (BOOL)supportPhoneFunction;

/**
 *  打电话
 *
 *  @param phoneNumber 需要拨通的电话号码
 *  @param completion  拨号完成的回调方法
 */
- (void)call:(NSString *)phoneNumber completion:(LKPhoneCallOverBlock)completion;
@end
