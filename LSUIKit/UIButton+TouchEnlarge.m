//
//  UIButton+TouchEnlarge.m
//  LSBaseExample
//
//  Created by Terry Zhang on 16/2/23.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UIButton+TouchEnlarge.h"
#import "LSBase.h"

static const NSString *kTouchEnlargeButton_top = @"kTouchEnlargeButton_top";
static const NSString *kTouchEnlargeButton_left = @"kTouchEnlargeButton_left";
static const NSString *kTouchEnlargeButton_bottom = @"kTouchEnlargeButton_bottom";
static const NSString *kTouchEnlargeButton_right = @"kTouchEnlargeButton_right";

@implementation UIButton (TouchEnlarge)

- (void)autoTouchEnLarge
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = 44.0 - bounds.size.width;
    CGFloat heightDelta = 44.0 - bounds.size.height;

    [self setAssociateValue:@(0.5 * heightDelta) withKey:(__bridge void *)(kTouchEnlargeButton_top)];
    [self setAssociateValue:@(0.5 * widthDelta) withKey:(__bridge void *)(kTouchEnlargeButton_left)];
    [self setAssociateValue:@(0.5 * heightDelta) withKey:(__bridge void *)(kTouchEnlargeButton_bottom)];
    [self setAssociateValue:@(0.5 * widthDelta) withKey:(__bridge void *)(kTouchEnlargeButton_right)];
}

- (void)setTouchEnlargeEdge:(CGFloat) size
{
    [self setAssociateValue:@(size) withKey:(__bridge void *)(kTouchEnlargeButton_top)];
    [self setAssociateValue:@(size) withKey:(__bridge void *)(kTouchEnlargeButton_left)];
    [self setAssociateValue:@(size) withKey:(__bridge void *)(kTouchEnlargeButton_bottom)];
    [self setAssociateValue:@(size) withKey:(__bridge void *)(kTouchEnlargeButton_right)];
}

- (void)setTouchEnlargeInset:(UIEdgeInsets)touchEnlargeInset
{
    [self setAssociateValue:@(touchEnlargeInset.top) withKey:(__bridge void *)(kTouchEnlargeButton_top)];
    [self setAssociateValue:@(touchEnlargeInset.left) withKey:(__bridge void *)(kTouchEnlargeButton_left)];
    [self setAssociateValue:@(touchEnlargeInset.bottom) withKey:(__bridge void *)(kTouchEnlargeButton_bottom)];
    [self setAssociateValue:@(touchEnlargeInset.right) withKey:(__bridge void *)(kTouchEnlargeButton_right)];
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge = [self getAssociatedValueForKey:(__bridge void *)(kTouchEnlargeButton_top)];
    NSNumber* rightEdge = [self getAssociatedValueForKey:(__bridge void *)(kTouchEnlargeButton_left)];
    NSNumber* bottomEdge = [self getAssociatedValueForKey:(__bridge void *)(kTouchEnlargeButton_bottom)];
    NSNumber* leftEdge = [self getAssociatedValueForKey:(__bridge void *)(kTouchEnlargeButton_right)];
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

- (UIView*)hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    if (self.hidden) {
        return nil;
    }
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}


@end
