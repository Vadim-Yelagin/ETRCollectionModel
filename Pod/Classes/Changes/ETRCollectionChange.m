//
//  ETRCollectionChange.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"

@implementation ETRCollectionChange

- (void)updateTableView:(UITableView *)tableView
{
    // stub
}

- (void)updateCollectionView:(UICollectionView *)collectionView
{
    // stub
}

- (ETRCollectionChange *)transformWithSectionMap:(NSInteger (^)(NSInteger))sectionMap
                                    indexPathMap:(NSIndexPath *(^)(NSIndexPath *))indexPathMap
{
    return nil; // stub
}

+ (NSArray *)mapIndexPaths:(NSArray *)indexPaths
                 withBlock:(NSIndexPath *(^)(NSIndexPath *))indexPathMap
{
    NSMutableArray* res = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath* path in indexPaths) {
        [res addObject:indexPathMap(path)];
    }
    return res;
}

+ (NSIndexSet *)mapSections:(NSIndexSet *)sections
                  withBlock:(NSInteger(^)(NSInteger))sectionMap
{
    NSMutableIndexSet *res = [NSMutableIndexSet indexSet];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx,
                                           BOOL *stop)
     {
         [res addIndex:sectionMap(idx)];
     }];
    return res;
}

@end
