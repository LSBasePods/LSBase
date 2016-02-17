//
//  UIView+LSBorder.m
//  LSBaseExample
//
//  Created by liulihui on 16/2/16.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UIView+LSBorder.h"
#import "UIView+LSFrame.h"
#import "objc/runtime.h"
#import "NSObject+RunTime.h"

static char TAG_BORDERDIC;
NSString *const key_Border_Color = @"key_Border_Color";
NSString *const key_Border_Width = @"key_Border_Width";
NSString *const key_Border_ContentInsets = @"key_Border_ContentInsets";

@implementation UIView (LSBorder)

- (void)showBorderPosition:(LSBorderPosition)borderPositions borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    BOOL top, left, bottom, right;
    if (borderPositions == LSBorderPositionAll) {
        top = YES;
        left = YES;
        bottom = YES;
        right = YES;
    } else {
        top = borderPositions & LSBorderPositionTop;
        left = borderPositions & LSBorderPositionLeft;
        bottom = borderPositions & LSBorderPositionBottom;
        right = borderPositions & LSBorderPositionRight;
    }
    
    NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
    [valueDic setValue:borderColor forKey:key_Border_Color];
    [valueDic setValue:@(borderWidth) forKey:key_Border_Width];
    [valueDic setValue:NSStringFromUIEdgeInsets(contentInsets) forKey:key_Border_ContentInsets];
    
    if (top) {
        [self.borderDic setObject:valueDic forKey:@(LSBorderPositionTop)];
    }
    if (left) {
        [self.borderDic setObject:valueDic forKey:@(LSBorderPositionLeft)];
    }
    if (bottom) {
        [self.borderDic setObject:valueDic forKey:@(LSBorderPositionBottom)];
    }
    if (right) {
        [self.borderDic setObject:valueDic forKey:@(LSBorderPositionRight)];
    }
}

- (void)showTopBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    [self showBorderPosition:LSBorderPositionTop borderColor:borderColor borderWidth:borderWidth contentInsets:contentInsets];
}

- (void)showBottomBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    [self showBorderPosition:LSBorderPositionBottom borderColor:borderColor borderWidth:borderWidth contentInsets:contentInsets];
}

- (void)showLeftBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    [self showBorderPosition:LSBorderPositionLeft borderColor:borderColor borderWidth:borderWidth contentInsets:contentInsets];
}

- (void)showRightBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    [self showBorderPosition:LSBorderPositionRight borderColor:borderColor borderWidth:borderWidth contentInsets:contentInsets];
}

#pragma mark - privite

- (void)setBorderDic:(NSMutableDictionary *)borderDic
{
    objc_setAssociatedObject(self, &TAG_BORDERDIC, borderDic, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)borderDic
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &TAG_BORDERDIC);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        [self setBorderDic:dic];
    }
    return dic;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector];
    });
}

+ (void)swizzleSelector
{
    [self swizzleInstanceMethod:@selector(layoutSubviews) with:@selector(LS_layoutSubviews)];
}

- (void)LS_layoutSubviews
{
    [self LS_layoutSubviews];
    [self showBorders];
    
}

- (void)showBorders
{
    NSArray *allKey = [self.borderDic allKeys];
    [allKey enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = self.borderDic[obj];
        if (dic) {
            UIColor *borderColor = dic[key_Border_Color];
            NSNumber *borderWidth = dic[key_Border_Width];
            NSString *contentInsets = dic[key_Border_ContentInsets];
            [self createBorderPosition:[obj integerValue] borderColor:borderColor borderWidth:[borderWidth floatValue] contentInsets:UIEdgeInsetsFromString(contentInsets)];
        }
    }];
}

- (void)createBorderPosition:(LSBorderPosition)borderPositions borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    BOOL top, left, bottom, right;
    if (borderPositions == LSBorderPositionAll) {
        top = YES;
        left = YES;
        bottom = YES;
        right = YES;
    } else {
        top = borderPositions & LSBorderPositionTop;
        left = borderPositions & LSBorderPositionLeft;
        bottom = borderPositions & LSBorderPositionBottom;
        right = borderPositions & LSBorderPositionRight;
    }
    if (top) {
        [self createTopBorderColor:borderColor borderWidth:borderWidth contentInsets:contentInsets];
    }
    if (left) {
        [self createLeftBorderColor:borderColor borderWidth:borderWidth contentInsets:contentInsets];
    }
    if (bottom) {
        [self createBottomBorderColor:borderColor borderWidth:borderWidth contentInsets:contentInsets];
    }
    if (right) {
        [self createRightBorderColor:borderColor borderWidth:borderWidth contentInsets:contentInsets];
    }
}

- (void)createTopBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(contentInsets.left, contentInsets.top, self.width - contentInsets.left - contentInsets.right, borderWidth);
    layer.backgroundColor = borderColor.CGColor;
    [self.layer addSublayer:layer];
}

- (void)createBottomBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(contentInsets.left, self.height - contentInsets.bottom - borderWidth, self.width - contentInsets.left - contentInsets.right, borderWidth);
    layer.backgroundColor = borderColor.CGColor;
    [self.layer addSublayer:layer];
}

- (void)createLeftBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(contentInsets.left, contentInsets.top, borderWidth, self.height - contentInsets.top - contentInsets.bottom);
    layer.backgroundColor = borderColor.CGColor;
    [self.layer addSublayer:layer];
}

- (void)createRightBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth contentInsets:(UIEdgeInsets)contentInsets
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(self.width - contentInsets.right - borderWidth, contentInsets.top, borderWidth, self.height - contentInsets.top - contentInsets.bottom);
    layer.backgroundColor = borderColor.CGColor;
    [self.layer addSublayer:layer];
}

@end
