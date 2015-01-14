//
//  ETRCollectionChangeItemReload.m
//
//  Created by Vadim Yelagin on 22/05/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeItemReload.h"

@implementation ETRCollectionChangeItemReload

- (void)updateTableView:(UITableView *)tableView
{
    [tableView reloadRowsAtIndexPaths:self.indexPaths
                     withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    [collectionView reloadItemsAtIndexPaths:self.indexPaths];
}

@end
