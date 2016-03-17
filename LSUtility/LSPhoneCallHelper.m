//
//  LSPhoneCallHelper.m
//  LSCommonService
//
//  Created by 白开水_孙 on 15/4/29.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "LSPhoneCallHelper.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

CFAbsoluteTime const LSPHONECALLFAILEDTIME = -100;

@interface LSPhoneCallHelper () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) LKPhoneCallOverBlock completion;
@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic) BOOL countPhoneTime;
@property (nonatomic) CFAbsoluteTime becomeActiveTime;;
@property (nonatomic) CFAbsoluteTime startTime;

@end

@implementation LSPhoneCallHelper
+ (instancetype)sharePhoneCallHelper
{
    static LSPhoneCallHelper *sharePhoneCallHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePhoneCallHelper = [[self alloc] init];
    });
    return sharePhoneCallHelper;
}

- (instancetype)init
{
    if (self = [super init]) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        
        _callCenter = [[CTCallCenter alloc] init];
        __weak typeof(self) blockself = self;
        _callCenter.callEventHandler = ^(CTCall* call) {
            if ([call.callState isEqualToString:CTCallStateDisconnected]) {
                CFAbsoluteTime time = LSPHONECALLFAILEDTIME;
                if (blockself.countPhoneTime) {
                    time = CFAbsoluteTimeGetCurrent() - blockself.startTime;
                }
                NSLog(@"phonecall lasts %.2f seconds",(time));
                blockself.countPhoneTime = NO;
                dispatch_async(dispatch_get_main_queue() , ^{
                    if (blockself.completion) {
                        blockself.completion(time);
                    }
                });
            } else if ([call.callState isEqualToString:CTCallStateConnected]) {
                blockself.startTime = CFAbsoluteTimeGetCurrent();
                blockself.countPhoneTime = YES;
            } else if ([call.callState isEqualToString:CTCallStateDialing]) {
                blockself.countPhoneTime = NO;
            } else {
                NSLog(@"Nothing is done");
            }
        };
    }
    return self;
}

- (BOOL)supportPhoneFunction {
    UIDevice *device = [UIDevice currentDevice];
    if ([@"iPhone" isEqualToString : device.model]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)call:(NSString *)phoneNumber completion:(LKPhoneCallOverBlock)completion
{
    if (phoneNumber.length == 0) {
        return;
    }
    self.completion = completion;
    _countPhoneTime = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]]]];
}
@end
