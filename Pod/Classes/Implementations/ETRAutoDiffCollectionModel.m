//
//  ETRAutoDiffCollectionModel.m
//  Stub
//
//  Created by Vadim Yelagin on 20/03/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRAutoDiffCollectionModel.h"
#import "ETRCollectionChangeBatch.h"
#import "ETRCollectionChangeItemDelete.h"
#import "ETRCollectionChangeItemInsert.h"
#import "ETRCollectionChangeItemMove.h"
#import "ETRCollectionChangeItemReload.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(Byte, ETRLCSMove) {
    ETRLCSFromPrevRow,
    ETRLCSFromPrevColumn,
    ETRLCSMatch
};

@implementation ETRAutoDiffCollectionModel
{
    RACSubject* _changes;
}

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        _items = [items copy];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithItems:nil];
}

- (RACSignal*)changes
{
    if (!_changes)
        _changes = [RACSubject subject];
    return _changes;
}

- (BOOL)isItem:(id)item1
    sameAsItem:(id)item2
{
    return [item1 isEqual:item2];
}

- (void)setItems:(NSArray *)items
{
    NSArray* a = self.items;
    NSArray* b = items;
    NSInteger na = a.count;
    NSInteger nb = b.count;
    _items = [items copy];
    ETRLCSMove* moves = malloc(sizeof(ETRLCSMove) * na * nb);
    NSInteger* lengths = malloc(sizeof(NSInteger) * na * nb);
    for (NSInteger ia = 0; ia < na; ia++) {
        for (NSInteger ib = 0; ib < nb; ib++) {
            ETRLCSMove curMove;
            NSInteger curLength;
            if ([self isItem:a[ia] sameAsItem:b[ib]]) {
                curMove = ETRLCSMatch;
                if (ia > 0 && ib > 0) {
                    curLength = lengths[(ia-1)*nb + (ib-1)] + 1;
                } else {
                    curLength = 1;
                }
            } else {
                NSInteger prevRowLength = 0;
                NSInteger prevColumnLength = 0;
                if (ia > 0) {
                    prevRowLength = lengths[(ia-1)*nb + ib];
                }
                if (ib > 0) {
                    prevColumnLength = lengths[ia*nb + (ib-1)];
                }
                if (prevRowLength > prevColumnLength) {
                    curMove = ETRLCSFromPrevRow;
                    curLength = prevRowLength;
                } else {
                    curMove = ETRLCSFromPrevColumn;
                    curLength = prevColumnLength;
                }
            }
            lengths[ia*nb + ib] = curLength;
            moves[ia*nb + ib] = curMove;
        }
    }
    free(lengths); lengths = 0;
    NSMutableArray* extraA = [NSMutableArray array];
    NSMutableArray* extraB = [NSMutableArray array];
    NSInteger ia = na - 1;
    NSInteger ib = nb - 1;
    NSMutableArray* reloads = [NSMutableArray array];
    while (ia >= 0 && ib >= 0) {
        switch (moves[ia*nb + ib]) {
            case ETRLCSFromPrevRow:
                [extraA addObject:@(ia)];
                --ia;
                break;
            case ETRLCSFromPrevColumn:
                [extraB addObject:@(ib)];
                --ib;
                break;
            case ETRLCSMatch:
                if (a[ia] != b[ib]) {
                    NSIndexPath* pathA = [NSIndexPath indexPathForRow:ia
                                                            inSection:0];
                    [reloads addObject:pathA];
                }
                --ia;
                --ib;
                break;
        }
    }
    free(moves); moves = 0;
    for (; ia >= 0; --ia) {
        [extraA addObject:@(ia)];
    }
    for (; ib >= 0; --ib) {
        [extraB addObject:@(ib)];
    }
    ETRCollectionChangeBatch* batch = [[ETRCollectionChangeBatch alloc] init];
    NSMutableArray* insertions = [NSMutableArray array];
    NSMutableArray* deletions = [NSMutableArray array];
    for (NSNumber* numA in extraA) {
        NSIndexPath* pathA = [NSIndexPath indexPathForRow:numA.integerValue
                                                inSection:0];
        id itemA = a[numA.integerValue];
        NSInteger idxB = [extraB indexOfObjectPassingTest:^BOOL(NSNumber* numB,
                                                                NSUInteger idx,
                                                                BOOL *stop)
                          {
                              id itemB = b[numB.integerValue];
                              return itemA == itemB;
                          }];
        if (idxB == NSNotFound) {
            [deletions addObject:pathA];
        } else {
            NSNumber* numB = extraB[idxB];
            NSIndexPath* pathB = [NSIndexPath indexPathForRow:numB.integerValue
                                                    inSection:0];
            [batch addChange:[[ETRCollectionChangeItemMove alloc]
                              initWithFromIndexPath:pathA
                              toIndexPath:pathB]];
            [extraB removeObjectAtIndex:idxB];
        }
    }
    for (NSNumber* numB in extraB) {
        NSIndexPath* pathB = [NSIndexPath indexPathForRow:numB.integerValue
                                                inSection:0];
        [insertions addObject:pathB];
    }
    if (reloads.count) {
        [batch addChange:[[ETRCollectionChangeItemReload alloc]
                          initWithIndexPaths:reloads]];
    }
    if (deletions.count) {
        [batch addChange:[[ETRCollectionChangeItemDelete alloc]
                          initWithIndexPaths:deletions]];
    }
    if (insertions.count) {
        [batch addChange:[[ETRCollectionChangeItemInsert alloc]
                          initWithIndexPaths:insertions]];
    }
    [_changes sendNext:batch];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.item];
}

- (NSString*)headerTitleForSection:(NSInteger)section
{
    return self.headerTitle;
}

- (NSString*)footerTitleForSection:(NSInteger)section
{
    return self.footerTitle;
}

@end
