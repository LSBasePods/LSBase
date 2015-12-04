//
//  NSObject+NSJSONSerialization.h
//  LSFoundation
//
//  Created by liulihui on 14/12/11.
//  Copyright (c) 2014年 BasePod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSJSONSerialization)

- (NSString *)LSJSONRepresentation;

@end


@interface NSString (NSJSONSerialization)

- (id)LSJSONValue;

@end
