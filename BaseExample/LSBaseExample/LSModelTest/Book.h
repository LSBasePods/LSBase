//
//  Book.h
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/5.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Book : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSNumber *pages;

@property (nonatomic, assign) BOOL hasRead;

CREATE_PROPERTY(user, User *, strong);
CREATE_ARRAY_PROPERTY(userList);

@end
