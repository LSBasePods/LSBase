//
//  UILabel+ContentInset.h
//  LSBaseExample
//
//  Created by liulihui on 16/2/15.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ContentInset)

/*
text会根据contentInsets来上下左右padding
autolayout的模式下contentInsets生效
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;


/*
 text会根据leftPadding缩进
 非autolayout的模式下使用
 */
- (void)showText:(NSString *)text leftPadding:(CGFloat)leftPadding;

@end
