//
//  ETRCollectionChangeItemMove.m
//
//  Created by Vadim Yelagin on 21/03/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeItemMove.h"

@implementation ETRCollectionChangeItemMove
{
    NSIndexPath* _fromIndexPath;
    NSIndexPath* _toIndexPath;
}

- (instancetype)initWithFromIndexPath:(NSIndexPath *)fromIndexPath
                          toIndexPath:(NSIndexPath *)toIndexPath
{
    self = [super init];
    if (self) {
        _fromIndexPath = fromIndexPath;
        _toIndexPath = toIndexPath;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFromIndexPath:nil
                           toIndexPath:nil];
}

- (void)updateTableView:(UITableView *)tableView
{
    [tableView moveRowAtIndexPath:_fromIndexPath
                      toIndexPath:_toIndexPath];
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    [collectionView moveItemAtIndexPath:_fromIndexPath
                            toIndexPath:_toIndexPath];
}

- (ETRCollectionChange *)transformWithSectionMap:(NSInteger (^)(NSInteger))sectionMap
                                    indexPathMap:(NSIndexPath *(^)(NSIndexPath *))indexPathMap
{
    return [[ETRCollectionChangeItemMove alloc] initWithFromIndexPath:indexPathMap(_fromIndexPath)
                                                          toIndexPath:indexPathMap(_toIndexPath)];
}

@end
