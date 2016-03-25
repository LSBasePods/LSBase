//
//  QYSpotlightManager.m
//  Example
//
//  Created by Terry Zhang on 15/11/20.
//  Copyright © 2015年 terry. All rights reserved.
//

#import "LSSpotlightManager.h"
#import "LSSpotlightSearchable.h"

@implementation LSSpotlightManager

/// 单例
+ (instancetype)sharedInstance
{
    static LSSpotlightManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LSSpotlightManager alloc] init];
    });
    return instance;
}

/// 后台添加 spotlight searchable Item
- (void)addSpotlightSearchableItemsWithObjects:(NSArray *)objects searchableMapping:(id<LSSpotlightSearchableMappingProtocol>)mapping completeBlk:(LSSearchableOperationComplete)complete;
{
    // 后台执行，图片读取比较耗时
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSError *error = nil;
        
        // 重新添加商品
        __weak LSSpotlightManager *weakSelf = self;
        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf insertItemWithObject:obj searchableMapping:mapping];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete ? complete(error) : nil;
        });
        
    });
}

/// 后台更新 spotlight searchable Item
- (void)updateSpotlightSearchableItemsWithObjects:(NSArray *)objects searchableMapping:(id<LSSpotlightSearchableMappingProtocol>)mapping  completeBlk:(LSSearchableOperationComplete)complete;
{
    [self addSpotlightSearchableItemsWithObjects:objects searchableMapping:mapping completeBlk:complete];
}

/// 后台更新 spotlight searchable Item
- (void)deleteSpotlightSearchableItemsWithObjects:(NSArray *)objects searchableMapping:(id<LSSpotlightSearchableMappingProtocol>)mapping  completeBlk:(LSSearchableOperationComplete)complete;
{
    __weak LSSpotlightManager *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        NSError *error = nil;

        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf deleteItemWithObject:obj searchableMapping:mapping];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete ? complete(error) : nil;
        });
    });
}

/// 删除所有的 spotlight searchable Item
- (void)deleteAllSpotlightSearchableItemsWithCompleteBlk:(LSSearchableOperationComplete)complete;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        NSError *error = nil;

        [[LSSpotlightSearchable sharedInstance] deleteAllItemes];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete ? complete(error) : nil;
        });
    });
}

#pragma mark - Private Methods

- (void)insertItemWithObject:(id)object searchableMapping:(id<LSSpotlightSearchableMappingProtocol>)mapping
{
    if (!mapping) {
#ifdef DEBUG
        [NSException raise:NSRangeException format:@"*** mapping is nil, please implementation QYSpotlightSearchableMappingProtocol"];
#endif
        return;
    }
    NSString *uniqueIdentifier = [mapping searchableIdentifierMappingFromData:object];
    CSSearchableItemAttributeSet *attributeSet  = [mapping searchableItemAttributeSetMappingFromData:object];
    // 添加 Spotlight 的搜索 Item
    [[LSSpotlightSearchable sharedInstance] insertItemWithAttributeSet:attributeSet uniqueIdentifier:uniqueIdentifier];
}

- (void)deleteItemWithObject:(id)object searchableMapping:(id<LSSpotlightSearchableMappingProtocol>)mapping
{
    if (!mapping) {
#ifdef DEBUG
        [NSException raise:NSRangeException format:@"*** mapping is nil, please implementation QYSpotlightSearchableMappingProtocol"];
#endif
        return;
    }
    NSString *uniqueIdentifier = [mapping searchableIdentifierMappingFromData:object];
    [[LSSpotlightSearchable sharedInstance] deleteItemsWithUniqueIdentifier:uniqueIdentifier];
}


@end
