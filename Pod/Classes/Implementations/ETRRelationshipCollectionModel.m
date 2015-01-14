//
//  ETRRelationshipCollectionModel.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"
#import "ETRCollectionChangeItemInsert.h"
#import "ETRCollectionChangeItemDelete.h"
#import "ETRCollectionChangeItemReload.h"
#import "ETRCollectionChangeReload.h"
#import "ETRRelationshipCollectionModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ETRRelationshipCollectionModel

@synthesize changes = _changes;

- (instancetype)initWithTarget:(id)target
                       keyPath:(NSString *)keyPath
                   headerTitle:(NSString *)headerTitle
                   footerTitle:(NSString *)footerTitle
{
    self = [super init];
    if (self) {
        _headerTitle = [headerTitle copy];
        _footerTitle = [footerTitle copy];
        _target = target;
        _keyPath = [keyPath copy];
        RACSignal* kvo = [target rac_valuesAndChangesForKeyPath:keyPath
                                                        options:0
                                                       observer:self];
        _changes = [kvo map:^ETRCollectionChange*(RACTuple* tuple)
                    {
                        NSDictionary* observation = tuple.second;
                        NSIndexSet* indexes = observation[NSKeyValueChangeIndexesKey];
                        NSMutableArray* indexPaths = [NSMutableArray arrayWithCapacity:indexes.count];
                        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                            [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
                        }];
                        NSKeyValueChange kind = [observation[NSKeyValueChangeKindKey] unsignedIntegerValue];
                        switch (kind) {
                            case NSKeyValueChangeSetting:
                                return [[ETRCollectionChangeReload alloc] init];
                            case NSKeyValueChangeInsertion:
                                return [[ETRCollectionChangeItemInsert alloc] initWithIndexPaths:indexPaths];
                            case NSKeyValueChangeRemoval:
                                return [[ETRCollectionChangeItemDelete alloc] initWithIndexPaths:indexPaths];
                            case NSKeyValueChangeReplacement:
                                return [[ETRCollectionChangeItemReload alloc] initWithIndexPaths:indexPaths];
                        }
                    }];
    }
    return self;
}

- (instancetype)initWithTarget:(id)target
                       keyPath:(NSString *)keyPath
                   headerTitle:(NSString *)headerTitle
{
    return [self initWithTarget:target
                        keyPath:keyPath
                    headerTitle:headerTitle
                    footerTitle:nil];
}

- (instancetype)initWithTarget:(id)target
                       keyPath:(NSString *)keyPath
{
    return [self initWithTarget:target
                        keyPath:keyPath
                    headerTitle:nil
                    footerTitle:nil];
}

- (instancetype)init
{
    return [self initWithTarget:nil
                        keyPath:nil
                    headerTitle:nil
                    footerTitle:nil];
}

- (NSArray*)relation
{
    return [self.target valueForKeyPath:self.keyPath];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self relation].count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self relation][indexPath.item];
}

- (NSString*)headerTitleForSection:(NSInteger)section
{
    return self.headerTitle;
}

- (NSString*)footerTitleForSection:(NSInteger)section
{
    return self.footerTitle;
}

- (BOOL)canDeleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.allowDelete;
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[self.target mutableOrderedSetValueForKeyPath:self.keyPath] removeObjectAtIndex:indexPath.item];
}

@end
