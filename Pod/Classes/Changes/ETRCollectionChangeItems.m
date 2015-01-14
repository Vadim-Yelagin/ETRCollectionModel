//
//  ETRCollectionChangeItems.m
//
//  Created by Vadim Yelagin on 14/10/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeItems.h"

@implementation ETRCollectionChangeItems

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath
{
    return [self initWithIndexPaths:@[indexPath]];
}

- (instancetype)initWithIndexPaths:(NSArray *)indexPaths
{
    self = [super init];
    if (self) {
        _indexPaths = [indexPaths copy];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithIndexPaths:@[]];
}

- (ETRCollectionChange *)transformWithSectionMap:(NSInteger (^)(NSInteger))sectionMap
                                    indexPathMap:(NSIndexPath *(^)(NSIndexPath *))indexPathMap
{
    NSArray* res = [ETRCollectionChange mapIndexPaths:self.indexPaths
                                            withBlock:indexPathMap];
    return [[[self class] alloc] initWithIndexPaths:res];
}

@end
