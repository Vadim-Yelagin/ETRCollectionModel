//
//  ETRCollectionChangeSectionReload.m
//
//  Created by Vadim Yelagin on 28/05/14.
//  Copyright (c) 2014 EastBanc IT. All rights reserved.
//

#import "ETRCollectionChangeSectionReload.h"

@implementation ETRCollectionChangeSectionReload

- (void)updateTableView:(UITableView *)tableView
{
    [tableView reloadSections:self.sections
             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    [collectionView reloadSections:self.sections];
}

@end
