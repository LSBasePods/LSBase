//
//  UIView+LSAutoLayout.h
//  LSUIKit
//
//  Created by liulihui on 15/6/4.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LSAutoLayoutAlignType) {
    LSAutoLayoutAlignCenterX = NSLayoutAttributeCenterX,
    LSAutoLayoutAlignCenterY = NSLayoutAttributeCenterY,
    LSAutoLayoutAlignTop = NSLayoutAttributeTop,
    LSAutoLayoutAlignLeft = NSLayoutAttributeLeft,
    LSAutoLayoutAlignBottom = NSLayoutAttributeBottom,
    LSAutoLayoutAlignRight = NSLayoutAttributeRight,
    LSAutoLayoutAlignBaseline = NSLayoutAttributeBaseline
};

typedef NS_ENUM(NSInteger, LSAutoLayoutSizeType) {
    LSAutoLayoutSizeWidth           = NSLayoutAttributeWidth,
    LSAutoLayoutSizeHeight          = NSLayoutAttributeHeight,
    LSAutoLayoutSizeNotAnAttribute  = NSLayoutAttributeNotAnAttribute
};

@interface UIView (LSAutoLayout)

#pragma mark - for SubViews
/**
 启用autolayout
 **/
- (void)useAutoLayout;

#pragma mark Pin Edges to SuperView
/**
 *  全屏加子view
 *
 *  @param contentView 子view
 *
 */
- (void)autoPinEdgesToSuperview;

/**
 *  添加子view
 *
 *  @param contentView 子view
 *  @param insets 相对父view上下左右空多少
 *
 */
- (void)autoPinEdgesToSuperviewWithInsets:(UIEdgeInsets)insets;

#pragma mark Align in SuperView
/**
 相对superView对齐，水平，垂直居中
 **/
- (void)autoCenterInSuperview;

/**
 相对superView对齐，根据type
 **/
- (void)autoAlignInSuperview:(LSAutoLayoutAlignType)alignType;

/**
 相对superView对齐，根据type, constant
 **/
- (void)autoAlignInSuperview:(LSAutoLayoutAlignType)alignType constant:(CGFloat)constant;

#pragma mark Align with Related View

/**
 *  相对relatedView对齐，self.alignType = relatedView.alignType + constant
 *  @param alignType
 *  @param relatedView
 *  @param constant
 */
- (void)autoAlign:(LSAutoLayoutAlignType)alignType relatedView:(UIView *)relatedView constant:(CGFloat)constant;

/**
 *  相对relatedView对齐，self.alignType = relatedView.relatedAlign + constant
 *  @param alignType
 *  @param relatedView
 *  @param relatedAlign
 *  @param constant
 */
- (void)autoAlign:(LSAutoLayoutAlignType)alignType relatedView:(UIView *)relatedView relatedAlign:(LSAutoLayoutAlignType)relatedAlign constant:(CGFloat)constant;

#pragma mark Match Size
/**
 *  添加宽高比约束 sizeType1 = sizeType2 * rate
 */
- (void)autoMatchSizeType:(LSAutoLayoutSizeType)sizeType1 sizeType2:(LSAutoLayoutSizeType)sizeType2 rate:(CGFloat)rate;

/**
 *  添加宽高相关约束 self.sizeType1 = relatedView.sizeType2 * rate + constant
 */
- (void)autoMatchSizeType:(LSAutoLayoutSizeType)sizeType1 relatedView:(UIView *)relatedView  sizeType2:(LSAutoLayoutSizeType)sizeType2 rate:(CGFloat)rate constant:(CGFloat)constant;

#pragma mark Set Size
/** 为 view 设置 指定的大小 */
- (void)autoSetSize:(CGSize)size;

/** 为 view 设置指定的大小 */
- (void)autoSetSizeType:(LSAutoLayoutSizeType)sizeType toSize:(CGFloat)size;

/** Sets the given dimension of the view to a specific size as a maximum or minimum. */
/** 为 view 设置指定值 或者 设置最大最小值 */
- (void)autoSetSizeType:(LSAutoLayoutSizeType)sizeType toSize:(CGFloat)size relation:(NSLayoutRelation)relation;

#pragma Clear Constraints
/**
 *  清除所有Constraint, 包括subview
 */
- (void)clearAllConstraints;

#pragma mark - for SuperView to Add Constaints with VFL String
/**
 *  VFL 方式
 *
 *  @param formatArr VFL数组
 *  @param opts
 *  @param metrics
 *  @param views
 *
 */
- (void)autoAddConstraintsWithVisualFormatArray:(NSArray *)formatArr options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

/**
 *  VFL 方式 和上一个的区别就是opts 也是数组
 */
- (void)autoAddConstraintsWithVisualFormatArray:(NSArray *)formatArr optionsArray:(NSArray *)optsArray metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

@end

@interface NSArray (LSAutoLayout)

/**
 *  数组内的view设定对齐条件
 *
 *  @param type 对齐方式
 *  @param relatedView 相对参照物
 *  @param constant 偏移量
 *
 */
- (void)autoAlignWithType:(LSAutoLayoutAlignType)type relatedView:(UIView *)relatedView constant:(CGFloat)constant;

@end
