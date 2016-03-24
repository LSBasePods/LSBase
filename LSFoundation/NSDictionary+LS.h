//
//  NSDictionary+LSTrim.h
//  LSFoundation
//
//  Created by liulihui on 15/1/8.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LS)

- (id)trim;

- (NSString *)toStringWithSplitString:(NSString *)splitString encode:(BOOL)encode;

@end
