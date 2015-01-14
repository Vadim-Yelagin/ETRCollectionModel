//
//  ETRCollectionChangeBatch.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeBatch.h"
#import "ETRCollectionChangeReload.h"

@implementation ETRCollectionChangeBatch

- (void)addChange:(ETRCollectionChange *)change
{
    if (_changes) {
        [_changes addObject:change];
    } else {
        _changes = [NSMutableArray arrayWithObject:change];
    }
}

- (void)updateTableView:(UITableView *)tableView
{
    [tableView beginUpdates];
    for (ETRCollectionChange* change in _changes) {
        [change updateTableView:tableView];
    }
    [tableView endUpdates];
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    [collectionView performBatchUpdates:^{
        for (ETRCollectionChange* change in _changes) {
            [change updateCollectionView:collectionView];
        }
    } completion:nil];
}

- (ETRCollectionChange *)transformWithSectionMap:(NSInteger (^)(NSInteger))sectionMap
                                    indexPathMap:(NSIndexPath *(^)(NSIndexPath *))indexPathMap
{
    ETRCollectionChangeBatch* res = [[ETRCollectionChangeBatch alloc] init];
    for (ETRCollectionChange* change in _changes) {
        ETRCollectionChange* transformed = [change transformWithSectionMap:sectionMap
                                                              indexPathMap:indexPathMap];
        if ([transformed isKindOfClass:[ETRCollectionChangeReload class]])
            return transformed;
        [res addChange:transformed];
    }
    return res;
}

@end
