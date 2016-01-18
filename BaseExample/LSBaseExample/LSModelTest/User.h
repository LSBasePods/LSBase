//
//  User.h
//  LSBaseExample
//
//  Created by Terry Zhang on 16/1/5.
//  Copyright © 2016年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+LSModel.h"

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSString *birthday;

@end
