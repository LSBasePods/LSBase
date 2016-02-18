//
//  UITableView+LSRegisterCellClass.h
//  LSBaseExample
//
//  Created by Terry Zhang on 16/2/18.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LSRegisterCellClass)

- (void)registerReuseCellClass:(Class)cellClass;

@end

@interface UICollectionView (LSRegisterCellClass)

- (void)registerReuseCellClass:(Class)cellClass;

@end

