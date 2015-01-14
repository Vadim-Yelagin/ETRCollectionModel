//
//  ETRCollectionChangeItemInsert.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeItemInsert.h"

@implementation ETRCollectionChangeItemInsert

- (void)updateTableView:(UITableView *)tableView
{
    [tableView insertRowsAtIndexPaths:self.indexPaths
                     withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    [collectionView insertItemsAtIndexPaths:self.indexPaths];
}

@end
