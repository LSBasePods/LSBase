//
//  Book.m
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/5.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import "Book.h"
#import "NSObject+LSModel.h"

@implementation Book

+ (NSDictionary *)discrepantKeys
{
    return @{@"hasRead":@"read"};
}

ARRAY_PROPERTY_SETTER(User, userList, setUserList)

@end


@implementation EnglishBook
@end