//
//  UILabel+CountDown.h
//  LSBaseExample
//
//  Created by Terry Zhang on 16/3/7.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LSLabelCountDownHandler)(UILabel *label, NSInteger currentNumber, BOOL stopped);

@interface UILabel (CountDown)

- (void)countDownSetStartNumber:(NSInteger)startNumber endNumber:(NSInteger)endNumber interval:(NSUInteger)interval countDownHandler:(LSLabelCountDownHandler)handler;

- (void)countDownStart;
- (void)countDownPause;
- (void)countDownResume;


@end
