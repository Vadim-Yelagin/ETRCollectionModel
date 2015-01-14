//
//  ETRCollectionChangeSectionDelete.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeSectionDelete.h"

@implementation ETRCollectionChangeSectionDelete

- (void)updateTableView:(UITableView *)tableView
{
    [tableView deleteSections:self.sections
             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    [collectionView deleteSections:self.sections];
}

@end
