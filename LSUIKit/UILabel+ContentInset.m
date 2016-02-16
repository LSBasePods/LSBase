//
//  UILabel+ContentInset.m
//  LSBaseExample
//
//  Created by liulihui on 16/2/15.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UILabel+ContentInset.h"
#import "objc/runtime.h"
#import "NSObject+RunTime.h"

static char TAG_CONTENTINSETS;

@implementation UILabel (ContentInset)

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    [self willChangeValueForKey:@"contentInsets"];
    NSString *stringInset = NSStringFromUIEdgeInsets(contentInsets);
    objc_setAssociatedObject(self, &TAG_CONTENTINSETS, stringInset, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"contentInsets"];}

- (UIEdgeInsets)contentInsets
{
    NSString *stringInset =  objc_getAssociatedObject(self, &TAG_CONTENTINSETS);
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (stringInset) {
        inset = UIEdgeInsetsFromString(stringInset);
    }
    return inset;
}

- (void)showText:(NSString *)text leftPadding:(CGFloat)leftPadding
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = leftPadding;
    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    self.attributedText = string;
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
    [self swizzleInstanceMethod:@selector(intrinsicContentSize) with:@selector(LS_intrinsicContentSize)];
}

- (CGSize)LS_intrinsicContentSize
{
    CGSize size = [self LS_intrinsicContentSize];
    size.width += (self.contentInsets.left + self.contentInsets.right);
    size.height += (self.contentInsets.top + self.contentInsets.bottom);
    return size;
}

@end
