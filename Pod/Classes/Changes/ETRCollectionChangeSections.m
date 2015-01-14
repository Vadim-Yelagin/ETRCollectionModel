//
//  ETRCollectionChangeSections.m
//
//  Created by Vadim Yelagin on 14/10/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeReload.h"
#import "ETRCollectionChangeSections.h"

@implementation ETRCollectionChangeSections

- (instancetype)initWithSection:(NSInteger)section
{
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:section];
    return [self initWithSections:indexSet];
}

- (instancetype)initWithSections:(NSIndexSet *)sections
{
    self = [super init];
    if (self) {
        _sections = [sections copy];
    }
    return self;
}

- (instancetype)init
{
    NSIndexSet* indexSet = [NSIndexSet indexSet];
    return [self initWithSections:indexSet];
}

- (ETRCollectionChange *)transformWithSectionMap:(NSInteger (^)(NSInteger))sectionMap
                                    indexPathMap:(NSIndexPath *(^)(NSIndexPath *))indexPathMap
{
    if (!sectionMap)
        return [[ETRCollectionChangeReload alloc] init];
    NSIndexSet* indexSet = [ETRCollectionChange mapSections:_sections
                                                  withBlock:sectionMap];
    return [[[self class] alloc] initWithSections:indexSet];
}

@end
