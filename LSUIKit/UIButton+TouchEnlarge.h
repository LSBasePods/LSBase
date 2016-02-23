//
//  UIButton+TouchEnlarge.h
//  LSBaseExample
//
//  Created by Terry Zhang on 16/2/23.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TouchEnlarge)

- (void)autoTouchEnLarge;
- (void)setTouchEnlargeEdge:(CGFloat) size;
- (void)setTouchEnlargeInset:(UIEdgeInsets)touchEnlargeInset;

@end
