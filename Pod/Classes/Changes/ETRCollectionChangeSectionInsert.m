//
//  ETRCollectionChangeSectionInsert.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeSectionInsert.h"

@implementation ETRCollectionChangeSectionInsert

- (void)updateTableView:(UITableView *)tableView
{
    [tableView insertSections:self.sections
             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    [collectionView insertSections:self.sections];
}

@end
