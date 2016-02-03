//
//  UITableView+indexPathCell.m
//  LSBaseExample
//
//  Created by Terry Zhang on 16/2/4.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UITableView+indexPathCell.h"
#import "NSObject+RunTime.h"
#import "UIView+LS.h"

@implementation UITableView (indexPathCell)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(dequeueReusableCellWithIdentifier:forIndexPath:) with:@selector(ls_dequeueReusableCellWithIdentifier:forIndexPath:)];
    });
}

- (__kindof UITableViewCell *)ls_dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    __kindof UITableViewCell *cell = [self ls_dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

@end
