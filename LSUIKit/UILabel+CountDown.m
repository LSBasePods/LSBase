//
//  UILabel+CountDown.m
//  LSBaseExample
//
//  Created by Terry Zhang on 16/3/7.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UILabel+CountDown.h"
#import "NSObject+RunTime.h"

const NSString *kLSCountDownLabel_startNumber = @"kLSCountDownLabel_startNumber";
const NSString *kLSCountDownLabel_endNumber = @"kLSCountDownLabel_endNumber";
const NSString *kLSCountDownLabel_interval = @"kLSCountDownLabel_interval";
const NSString *kLSCountDownLabel_currentNumber = @"kLSCountDownLabel_currentNumber";
const NSString *kLSCountDownLabel_handler = @"kLSCountDownLabel_handler";
const NSString *kLSCountDownLabel_timer = @"kLSCountDownLabel_timer";

@interface UILabel ()

@property (nonatomic, assign) NSInteger startNumber;
@property (nonatomic, assign) NSInteger endNumber;
@property (nonatomic, assign) NSUInteger countInterval; // default is 0. when it is 0, use sqrtf(endNumber - startNumber) which is faster.

@property (nonatomic, assign) NSInteger currentNumber;
@property (nonatomic, copy) LSLabelCountDownHandler countDownHandeler;


@end

@implementation UILabel (CountDown)

- (void)countDownSetStartNumber:(NSInteger)startNumber endNumber:(NSInteger)endNumber interval:(NSUInteger)interval countDownHandler:(LSLabelCountDownHandler)handler
{
    NSParameterAssert(startNumber != endNumber);
    self.startNumber = startNumber;
    self.endNumber = endNumber;
    self.currentNumber = startNumber;
    self.countInterval = interval;
    self.countDownHandeler = handler;

    handler ? handler(self, startNumber, startNumber == endNumber) : 0;
}

- (void)countDownStart
{
    if ([[self getAssociatedValueForKey:(__bridge void *)kLSCountDownLabel_startNumber] isEqual:[self getAssociatedValueForKey:(__bridge void *)kLSCountDownLabel_endNumber]]) {
        self.countDownHandeler ? self.countDownHandeler(self, self.currentNumber, YES) : nil;
        return;
    }
    
    [self.countDownTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)countDownPause
{
    self.countDownTimer.paused = YES;
    self.countDownHandeler ? self.countDownHandeler(self, self.currentNumber, YES) : nil;
}

- (void)countDownResume
{
    self.countDownTimer.paused = NO;
}

#pragma mark - PV
- (void)lsCountDown
{
    NSInteger interval = labs(self.currentNumber - self.endNumber);
    NSInteger c = 0;
    if (self.countInterval > interval) {
        c = interval;
    }
    else {
        c = self.countInterval ? : (int)sqrtf(interval);
    }
    
    self.currentNumber = (self.endNumber > self.currentNumber) ? self.currentNumber + c : self.currentNumber - c;
        
    if (self.countDownHandeler) {
        self.countDownHandeler(self, self.currentNumber ,(self.currentNumber == self.endNumber));
    }
    
    if (self.currentNumber == self.endNumber) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

#pragma mark - Property Getters & Setters
- (NSInteger)startNumber
{
    NSNumber *startNumber = [self getAssociatedValueForKey:(__bridge void *)kLSCountDownLabel_startNumber];
    return startNumber.integerValue;
}

- (void)setStartNumber:(NSInteger)startNumber
{
    self.currentNumber = startNumber;
    [self setAssociateValue:@(startNumber) withKey:(__bridge void *)(kLSCountDownLabel_startNumber)];
}

- (NSInteger)endNumber
{
    NSNumber *endNumber = [self getAssociatedValueForKey:(__bridge void *)kLSCountDownLabel_endNumber];
    return endNumber.integerValue;
}

- (void)setEndNumber:(NSInteger)endNumber
{
    [self setAssociateValue:@(endNumber) withKey:(__bridge void *)(kLSCountDownLabel_endNumber)];
}

- (NSInteger)currentNumber
{
    NSNumber *currentNumber = [self getAssociatedValueForKey:(__bridge void *)kLSCountDownLabel_currentNumber];
    return currentNumber.integerValue;
}

- (void)setCurrentNumber:(NSInteger)currentNumber
{
    [self setAssociateValue:@(currentNumber) withKey:(__bridge void *)(kLSCountDownLabel_currentNumber)];
}

- (NSUInteger)countInterval
{
    NSNumber *interval = [self getAssociatedValueForKey:(__bridge void *)kLSCountDownLabel_interval];
    return interval.unsignedIntegerValue;
}

- (void)setCountInterval:(NSUInteger)countInterval
{
    [self setAssociateValue:@(countInterval) withKey:(__bridge void *)(kLSCountDownLabel_interval)];
}

- (CADisplayLink *)countDownTimer
{
    CADisplayLink *countDownTimer = [self getAssociatedValueForKey:(__bridge void *)kLSCountDownLabel_timer];
    if (!countDownTimer) {
        countDownTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(lsCountDown)];
        countDownTimer.frameInterval = 60.;
    }
    return countDownTimer;
}

- (void)setCountDownTimer:(CADisplayLink *)countDownTimer
{
    [self setAssociateValue:countDownTimer withKey:(__bridge void *)(kLSCountDownLabel_timer)];
}
- (LSLabelCountDownHandler)countDownHandeler
{
    return [self getAssociatedValueForKey:(__bridge void *)kLSCountDownLabel_handler];
}

- (void)setCountDownHandeler:(LSLabelCountDownHandler)countDownHandeler
{
    [self setAssociateValue:countDownHandeler withKey:(__bridge void *)(kLSCountDownLabel_handler)];
}


@end
