//
//  ETROuterUnionCollectionModel.m
//
//  Created by Vadim Yelagin on 16/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETROuterUnionCollectionModel.h"

@implementation ETROuterUnionCollectionModel

- (NSInteger)numberOfSections
{
    NSInteger sum = 0;
    for (ETRCollectionModel *col in self.collections) {
        sum += [col numberOfSections];
    }
    return sum;
}

- (BOOL)supportsSectionUpdates
{
    return YES;
}

- (NSInteger)globalSectionForLocalSection:(NSInteger)section
                          collectionIndex:(NSInteger)collectionIndex
{
    NSInteger currentCollection = 0;
    for (ETRCollectionModel *col in self.collections) {
        if (currentCollection == collectionIndex)
            break;
        section += [col numberOfSections];
        currentCollection++;
    }
    return section;
}

- (NSInteger)localSectionForGlobalSection:(NSInteger)section
                          collectionIndex:(NSInteger*)collectioIndexPtr
{
    NSInteger collectionIndex = 0;
    for (ETRCollectionModel *col in self.collections) {
        NSInteger num = [col numberOfSections];
        if (section < num) {
            break;
        } else {
            section -= num;
        }
        collectionIndex++;
    }
    if (collectioIndexPtr)
        *collectioIndexPtr = collectionIndex;
    return section;
}

@end
