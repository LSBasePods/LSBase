//
//  UIBarButtonItem+LS.h
//  LSBaseExample
//
//  Created by Terry Zhang on 15/12/4.
//  Copyright © 2015年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LS)

/**
 The block that invoked when the item is selected. The objects captured by block
 will retained by the ButtonItem.
 
 @discussion This param is conflict with `target` and `action` property.
 Set this will set `target` and `action` property to some internal objects.
 */
@property (nonatomic, copy) void (^actionBlock)(id);

@end
