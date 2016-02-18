//
//  UILabel+LS.m
//  LSBaseExample
//
//  Created by liulihui on 16/2/18.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UILabel+LS.h"

@implementation UILabel (LS)

- (void)setText:(NSString *)text textColor:(UIColor *)textColor textFont:(UIFont *)textFont
{
    self.text = text;
    self.textColor = textColor;
    self.font = textFont;
}
@end
