//
//  UIView+LS.h
//  LSUIKit
//
//  Created by liulihui on 15/6/4.
//  Copyright (c) 2015年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LSAutoLayout.h"
#import "UIView+LSRemoveAllSubview.h"
#import "UIView+LSFrame.h"
#import "UIView+Genie.h"

@interface NSObject (ViewModelMapping)

+ (void)view:(UIView *)view mappingModel:(id)data;

@end

@interface UIView (LS)

@property (nonatomic, strong) NSDictionary *lsUserInfo;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (NSString *)className;

- (UIViewController *)myViewController;

- (void)configViewFromData:(id)data;

@end


