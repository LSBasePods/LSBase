//
//  UIView+LSAutoLayout.m
//  LSUIKit
//
//  Created by liulihui on 15/6/4.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import "UIView+LSAutoLayout.h"

@implementation UIView (LSAutoLayout)

#pragma mark - for SubViews

- (void)useAutoLayout
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark Pin Edges to SuperView
- (void)autoPinEdgesToSuperview
{
    [self autoPinEdgesToSuperviewWithInsets:UIEdgeInsetsZero];
}

- (void)autoPinEdgesToSuperviewWithInsets:(UIEdgeInsets)insets
{
    UIView *superView = self.superview;
    
    NSDictionary *view = @{@"contentView":self};
    NSDictionary *metrics = @{@"top": @(insets.top), @"left": @(insets.left), @"bottom": @(insets.bottom), @"right": @(insets.right)};
    NSString *H01 = @"H:|-left-[contentView]-right-|";
    NSString *V01 = @"V:|-top-[contentView]-bottom-|";
    
    [superView autoAddConstraintsWithVisualFormatArray:@[H01,V01] options:0 metrics:metrics views:view];
}

#pragma mark Align in SuperView
- (void)autoCenterInSuperview
{
    [self autoAlignInSuperview:LSAutoLayoutAlignCenterX];
    [self autoAlignInSuperview:LSAutoLayoutAlignCenterY];
}

- (void)autoAlignInSuperview:(LSAutoLayoutAlignType)alignType
{
    [self autoAlignInSuperview:alignType constant:.0];
}

- (void)autoAlignInSuperview:(LSAutoLayoutAlignType)alignType constant:(CGFloat)constant;
{
    UIView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    [self autoAlign:alignType relatedView:superview constant:constant];
}

#pragma mark Align with Related View
- (void)autoAlign:(LSAutoLayoutAlignType)alignType relatedView:(UIView *)relatedView constant:(CGFloat)constant
{
    UIView *superview = [self ls_commonSuperviewWithView:relatedView];
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    NSLayoutAttribute attribute = (NSLayoutAttribute)alignType;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:attribute multiplier:1.0f constant:constant]];
}

- (void)autoAlign:(LSAutoLayoutAlignType)alignType relatedView:(UIView *)relatedView relatedAlign:(LSAutoLayoutAlignType)relatedAlign constant:(CGFloat)constant
{
    UIView *superview = [self ls_commonSuperviewWithView:relatedView];
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    NSLayoutAttribute attribute1 = (NSLayoutAttribute)alignType;
    NSLayoutAttribute attribute2 = (NSLayoutAttribute)relatedAlign;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute1 relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:attribute2 multiplier:1.0f constant:constant]];
}

#pragma mark Match Size
- (void)autoMatchSizeType:(LSAutoLayoutSizeType)sizeType1 sizeType2:(LSAutoLayoutSizeType)sizeType2 rate:(CGFloat)rate
{
    UIView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:(NSLayoutAttribute)sizeType1 relatedBy:NSLayoutRelationEqual toItem:self attribute:(NSLayoutAttribute)sizeType2 multiplier:rate constant:.0]];
}

- (void)autoMatchSizeType:(LSAutoLayoutSizeType)sizeType1 relatedView:(UIView *)relatedView  sizeType2:(LSAutoLayoutSizeType)sizeType2 rate:(CGFloat)rate constant:(CGFloat)constant
{
    UIView *superview = [self ls_commonSuperviewWithView:relatedView];
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:(NSLayoutAttribute)sizeType1 relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:(NSLayoutAttribute)sizeType2 multiplier:rate constant:constant]];
}

#pragma mark Set Size
- (void)autoSetSize:(CGSize)size
{
    [self autoSetSizeType:LSAutoLayoutSizeWidth toSize:size.width];
    [self autoSetSizeType:LSAutoLayoutSizeHeight toSize:size.height];
}

- (void)autoSetSizeType:(LSAutoLayoutSizeType)sizeType toSize:(CGFloat)size
{
    [self autoSetSizeType:sizeType toSize:size relation:NSLayoutRelationEqual];
}

- (void)autoSetSizeType:(LSAutoLayoutSizeType)sizeType toSize:(CGFloat)size relation:(NSLayoutRelation)relation
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:(NSLayoutAttribute)sizeType relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:size];
    [self addConstraint:constraint];
}

#pragma Clear Constraints
- (void)clearAllConstraints
{
    [self removeConstraints:self.constraints];
    
    for (UIView *sub in [self subviews]) {
        [sub clearAllConstraints];
    }
}

#pragma mark - for SuperView to Add Constaints with VFL String
- (void)autoAddConstraintsWithVisualFormatArray:(NSArray *)formatArr options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    for (NSString *format in formatArr) {
        NSAssert([format isKindOfClass:[NSString class]], @"formatArr must be array of NSString");
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views]];
    }
}

- (void)autoAddConstraintsWithVisualFormatArray:(NSArray *)formatArr optionsArray:(NSArray *)optsArray metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    [formatArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutFormatOptions opts = [[optsArray objectAtIndex:idx] integerValue];
        NSAssert([obj isKindOfClass:[NSString class]], @"formatArr must be array of NSString");
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:obj options:opts metrics:metrics views:views]];
    }];
}

#pragma mark - Private Methods

- (void)autoRemoveConstraintsAffectingViewIncludingImplicitConstraints:(BOOL)shouldRemoveImplicitConstraints
{
    NSMutableArray *constraintsToRemove = [NSMutableArray new];
    UIView *startView = self;
    do {
        for (NSLayoutConstraint *constraint in startView.constraints) {
            BOOL isImplicitConstraint = [NSStringFromClass([constraint class]) isEqualToString:@"NSContentSizeLayoutConstraint"];
            if (shouldRemoveImplicitConstraints || !isImplicitConstraint) {
                if (constraint.firstItem == self || constraint.secondItem == self) {
                    [constraintsToRemove addObject:constraint];
                }
            }
        }
        startView = startView.superview;
    } while (startView);
    [UIView autoRemoveConstraints:constraintsToRemove];
}

+ (void)autoRemoveConstraints:(NSArray *)constraints
{
    for (id object in constraints) {
        if ([object isKindOfClass:[NSLayoutConstraint class]]) {
            [self autoRemoveConstraint:((NSLayoutConstraint *)object)];
        } else {
            NSAssert(nil, @"All constraints to remove must be instances of NSLayoutConstraint.");
        }
    }
}

+ (void)autoRemoveConstraint:(NSLayoutConstraint *)constraint
{
    if (constraint.secondItem) {
        UIView *commonSuperview = [constraint.firstItem ls_commonSuperviewWithView:constraint.secondItem];
        while (commonSuperview) {
            if ([commonSuperview.constraints containsObject:constraint]) {
                [commonSuperview removeConstraint:constraint];
                return;
            }
            commonSuperview = commonSuperview.superview;
        }
    }
    else {
        [constraint.firstItem removeConstraint:constraint];
        return;
    }
    NSAssert(nil, @"Failed to remove constraint: %@", constraint);
}

/// 返回 最小公共 superView
- (UIView *)ls_commonSuperviewWithView:(UIView *)peerView
{
    UIView *commonSuperview = nil;
    UIView *startView = self;
    do {
        if ([peerView isDescendantOfView:startView]) {
            commonSuperview = startView;
        }
        startView = startView.superview;
    } while (startView && !commonSuperview);
    NSAssert(commonSuperview, @"Can't constrain two views that do not share a common superview. Make sure that both views have been added into the same view hierarchy.");
    return commonSuperview;
}

@end

@implementation NSArray (LSAutoLayout)

- (void)autoAlignWithType:(LSAutoLayoutAlignType)type relatedView:(UIView *)relatedView constant:(CGFloat)constant
{
    for (UIView *view in self) {
        if ([view isKindOfClass:[UIView class]]) {
            [view autoAlign:type relatedView:relatedView constant:constant];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
    }
}

#pragma mark - Privite
- (BOOL)ls_isContainsMinimumNumberOfViews:(NSUInteger)minimumNumberOfViews
{
    NSUInteger numberOfViews = 0;
    for (id object in self) {
        if ([object isKindOfClass:[UIView class]]) {
            numberOfViews++;
            if (numberOfViews >= minimumNumberOfViews) {
                return YES;
            }
        }
    }
    return numberOfViews >= minimumNumberOfViews;
}

@end
