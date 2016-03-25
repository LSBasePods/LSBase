//
//  CSSearchableItemAttributeSet+QY.m
//  Example
//
//  Created by Terry Zhang on 15/11/23.
//  Copyright © 2015年 terry. All rights reserved.
//

#import "CSSearchableItemAttributeSet+LS.h"

@implementation CSSearchableItemAttributeSet (LS)

+ (instancetype)lsAttributeSet
{
    return [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeData];
}

@end
