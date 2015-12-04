//
//  LSCommonInfo.h
//  LSBaseExample
//
//  Created by Terry Zhang on 15/12/4.
//  Copyright © 2015年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LSCommonInfo : NSString

# pragma mark - App Info
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
/// Whether this app is pirated (not install from appstore).
+ (BOOL)isPirated;
/// Whether this app is being debugged (debugger attached).
+ (BOOL)isBeingDebugged;
/// Whether the device is a simulator.

# pragma mark - Device Info

//设备唯一标示
+ (NSString *)udid;
//ip地址
+ (NSString *)localIPAddress;
//基站IP
+ (NSString *)cellIPAddress;
//系统版本
+ (NSString *)iosVersion;
//设备类型
+ (NSString *)iosModel;
//电池状态
+ (UIDeviceBatteryState)batteryState;
//设备大小
+ (NSString *)totalDiskspace;
//剩余空间
+ (NSString *)freeDiskspace;
//具体设备
+ (NSString *)machineType;
//设备的网络状态
+ (NSString *)networkDetailStatusDescription;
//是不是plus
+ (BOOL)isPlus;
///是不是模拟器
+ (BOOL)isSimulator;
/// Whether the device is jailbroken.
+ (BOOL)isJailbroken;
/// Wherher the device can make phone calls.
+ (BOOL)canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");
/// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
+ (NSString *)machineModel;
/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
+ (NSString *)machineModelName;

@end
