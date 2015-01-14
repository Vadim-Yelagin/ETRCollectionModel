//
//  ETRCollectionChangeReload.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeReload.h"

@implementation ETRCollectionChangeReload

- (void)updateTableView:(UITableView *)tableView
{
    [tableView reloadData];
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    [collectionView reloadData];
}

- (ETRCollectionChange *)transformWithSectionMap:(NSInteger (^)(NSInteger))sectionMap
                                    indexPathMap:(NSIndexPath *(^)(NSIndexPath *))indexPathMap
{
    return self;
}

@end
