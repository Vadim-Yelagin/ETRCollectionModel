//
//  ETRCollectionChangeItems.h
//
//  Created by Vadim Yelagin on 14/10/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"

@interface ETRCollectionChangeItems : ETRCollectionChange

@property (nonatomic, copy, readonly) NSArray *indexPaths;

- (instancetype)initWithIndexPath:(NSIndexPath*)indexPath;
- (instancetype)initWithIndexPaths:(NSArray*)indexPaths NS_DESIGNATED_INITIALIZER;

@end
