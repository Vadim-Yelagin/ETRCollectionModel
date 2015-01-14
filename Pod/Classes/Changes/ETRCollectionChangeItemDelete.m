//
//  ETRCollectionChangeItemDelete.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeItemDelete.h"

@implementation ETRCollectionChangeItemDelete

- (void)updateTableView:(UITableView *)tableView
{
    [tableView deleteRowsAtIndexPaths:self.indexPaths
                     withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    [collectionView deleteItemsAtIndexPaths:self.indexPaths];
}

@end
