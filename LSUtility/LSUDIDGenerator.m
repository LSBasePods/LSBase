//
//  LSUDIDGenerator.m
//  LSFoundation
//
//  Created by liulihui on 14/12/8.
//  Copyright (c) 2014年 BasePod. All rights reserved.
//

#import "LSUDIDGenerator.h"
#import "LSKeychain.h"
#import <UIKit/UIKit.h>

#warning TODO
static NSString *serviceName = @"BasePodGroupsService";
static NSString *udidName = @"BasePodGroupsUDID";
static NSString *pasteboardType = @"BasePodGroupsContent";
static NSString *keychainGroup = @"com.xxx.xxx";

@interface LSUDIDGenerator ()

@property (nonatomic, strong) LSKeychain *myKeyChain;
@property (nonatomic, copy) NSString *udid;
@property (nonatomic, copy) NSString *appBundleName;

@end


@implementation LSUDIDGenerator

+ (LSUDIDGenerator *)sharedInstance
{
    static dispatch_once_t pred;
    static LSUDIDGenerator *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[LSUDIDGenerator alloc] init];
    });
    return sharedInstance;
}


- (void)saveUDID:(NSString *)udid
{
    BOOL saveOk = NO;
    NSData *udidData = [self.myKeyChain find:udidName];
    if (udidData == nil) {
        saveOk = [self.myKeyChain insert:udidName data:[self changeStringToData:udid]];
    }else{
        saveOk = [self.myKeyChain update:udidName data:[self changeStringToData:udid]];
    }
    if (!saveOk) {
        [self createPasteBoradValue:udid forIdentifier:udidName];
    }
}

- (NSString *)udid
{
    if (!_udid) {
        _udid = [[self getMyUDID] copy];
    }
    return _udid;
}

#pragma mark - privite method
- (NSString *)appBundleName
{
    if (!_appBundleName) {
        NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
        NSArray *components = [identifier componentsSeparatedByString:@"."];
        if (components.count > 2) {
            _appBundleName = [components objectAtIndex:2];
        } else {
            _appBundleName = @"";
        }
    }
    return _appBundleName;
}

- (LSKeychain *)myKeyChain
{
    if (!_myKeyChain) {
        _myKeyChain = [[LSKeychain alloc] initWithService:serviceName withGroup:keychainGroup];
    }
    return _myKeyChain;
}

- (NSData *)changeStringToData:(NSString *)str
{
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)createUDID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    NSString *udid = (__bridge NSString *)string;
    udid = [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(string);
    return udid;
}

- (NSString *)getMyUDID
{
    NSData *udidData = [self.myKeyChain find:udidName];
    NSString *udid = nil;
    if (!udidData) {
        udid = [self createUDID];
        [self saveUDID:udid];
    } else {
        NSString *temp = [[NSString alloc] initWithData:udidData encoding:NSUTF8StringEncoding];
        udid = [NSString stringWithFormat:@"%@", temp];
    }
    if (udid.length == 0) {
        udid = [self readPasteBoradforIdentifier:udidName];
    }
    return udid;
}

- (void)createPasteBoradValue:(NSString *)value forIdentifier:(NSString *)identifier
{
    UIPasteboard *pb = [UIPasteboard pasteboardWithName:serviceName create:YES];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:value forKey:identifier];
    NSData *dictData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [pb setData:dictData forPasteboardType:pasteboardType];
}

- (NSString *)readPasteBoradforIdentifier:(NSString *)identifier
{
    
    UIPasteboard *pb = [UIPasteboard pasteboardWithName:serviceName create:YES];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[pb dataForPasteboardType:pasteboardType]];
    return [dict objectForKey:identifier];
}

@end
