//
//  ETRCollectionChange.h
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

@import UIKit;

@interface ETRCollectionChange : NSObject

- (void)updateTableView:(UITableView*)tableView;
- (void)updateCollectionView:(UICollectionView*)collectionView;

- (ETRCollectionChange*)transformWithSectionMap:(NSInteger(^)(NSInteger))sectionMap
                                   indexPathMap:(NSIndexPath*(^)(NSIndexPath*))indexPathMap;

+ (NSArray*)mapIndexPaths:(NSArray*)indexPaths
                withBlock:(NSIndexPath*(^)(NSIndexPath*))indexPathMap;

+ (NSIndexSet*)mapSections:(NSIndexSet*)sections
                 withBlock:(NSInteger(^)(NSInteger))sectionMap;

@end
