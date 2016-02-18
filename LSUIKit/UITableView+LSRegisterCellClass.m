//
//  UITableView+LSRegisterCellClass.m
//  LSBaseExample
//
//  Created by Terry Zhang on 16/2/18.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "UITableView+LSRegisterCellClass.h"

@implementation UITableView (LSRegisterCellClass)

- (void)registerReuseCellClass:(Class)cellClass
{
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

@end

@implementation UICollectionView (LSRegisterCellClass)

- (void)registerReuseCellClass:(Class)cellClass
{
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

@end
