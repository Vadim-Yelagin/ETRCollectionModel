//
//  ETRCompositeCollectionModel.m
//
//  Created by Vadim Yelagin on 16/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"
#import "ETRCompositeCollectionModel.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ETRCompositeCollectionModel

@synthesize changes = _changes;

- (instancetype)initWithCollections:(NSArray *)collections
{
    self = [super init];
    if (self) {
        _collections = [NSArray arrayWithArray:collections];
        NSMutableArray* signals = [NSMutableArray arrayWithCapacity:collections.count];
        NSInteger colIndex = 0;
        for (ETRCollectionModel *col in collections) {
            RACSignal* colChanges = [col changes];
            if (colChanges) {
                [signals addObject:[colChanges map:^RACTuple*(ETRCollectionChange* change) {
                    return [RACTuple tupleWithObjects:change, @(colIndex), nil];
                }]];
            }
            colIndex++;
        }
        @weakify(self);
        _changes = [[RACSignal merge:signals] reduceEach:^ETRCollectionChange*(ETRCollectionChange* change,
                                                                               NSNumber* colIndex)
                    {
                        @strongify(self);
                        NSInteger collectionIndex = colIndex.integerValue;
                        NSInteger (^sectionMap)(NSInteger) = nil;
                        if ([self supportsSectionUpdates]) {
                            sectionMap = ^NSInteger(NSInteger section)
                            {
                                return [self globalSectionForLocalSection:section
                                                          collectionIndex:collectionIndex];
                            };
                        }
                        return [change transformWithSectionMap:sectionMap
                                                  indexPathMap:^NSIndexPath *(NSIndexPath *indexPath)
                                {
                                    return [self globalIndexPathForLocalIndexPath:indexPath
                                                                  collectionIndex:collectionIndex];
                                }];
                    }];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithCollections:@[]];
}

- (BOOL)supportsSectionUpdates
{
    return NO;
}

- (NSInteger)globalSectionForLocalSection:(NSInteger)section
                          collectionIndex:(NSInteger)collectionIndex
{
    return section;
}

- (NSInteger)localSectionForGlobalSection:(NSInteger)section
                          collectionIndex:(NSInteger*)collectioIndexPtr
{
    if (collectioIndexPtr)
        *collectioIndexPtr = 0;
    return section;
}

- (NSIndexPath*)globalIndexPathForLocalIndexPath:(NSIndexPath*)indexPath
                                 collectionIndex:(NSInteger)collectionIndex
{
    NSInteger section = [self globalSectionForLocalSection:indexPath.section
                                           collectionIndex:collectionIndex];
    return [NSIndexPath indexPathForRow:indexPath.row
                              inSection:section];
}

- (NSIndexPath*)localIndexPathForGlobalIndexPath:(NSIndexPath*)indexPath
                                 collectionIndex:(NSInteger*)collectioIndexPtr
{
    NSInteger section = [self localSectionForGlobalSection:indexPath.section
                                           collectionIndex:collectioIndexPtr];
    return [NSIndexPath indexPathForRow:indexPath.row
                              inSection:section];
}

- (NSInteger)numberOfSections
{
    return 0; // stub
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    NSInteger collection = 0;
    NSInteger local = [self localSectionForGlobalSection:section
                                         collectionIndex:&collection];
    return [self.collections[collection] numberOfItemsInSection:local];
}

- (NSString *)headerTitleForSection:(NSInteger)section
{
    NSInteger idx = 0;
    NSInteger local = [self localSectionForGlobalSection:section
                                         collectionIndex:&idx];
    ETRCollectionModel *collection = self.collections[idx];
    return [collection headerTitleForSection:local];
}

- (NSString *)footerTitleForSection:(NSInteger)section
{
    NSInteger idx = 0;
    NSInteger local = [self localSectionForGlobalSection:section
                                         collectionIndex:&idx];
    ETRCollectionModel *collection = self.collections[idx];
    return [collection footerTitleForSection:local];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger collectionIndex = 0;
    NSIndexPath* local = [self localIndexPathForGlobalIndexPath:indexPath
                                                collectionIndex:&collectionIndex];
    return local ? [self.collections[collectionIndex] itemAtIndexPath:local] : nil;
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath
                      completion:(void (^)(void))completion
{
    NSInteger collectionIndex = 0;
    NSIndexPath* local = [self localIndexPathForGlobalIndexPath:indexPath
                                                collectionIndex:&collectionIndex];
    if (local) {
        ETRCollectionModel *col = self.collections[collectionIndex];
        [col didSelectItemAtIndexPath:local completion:completion];
    }
}

- (BOOL)canDeleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger collectionIndex = 0;
    NSIndexPath* local = [self localIndexPathForGlobalIndexPath:indexPath
                                                collectionIndex:&collectionIndex];
    if (local) {
        ETRCollectionModel *col = self.collections[collectionIndex];
        return [col canDeleteItemAtIndexPath:local];
    }
    return NO;
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger collectionIndex = 0;
    NSIndexPath* local = [self localIndexPathForGlobalIndexPath:indexPath
                                                collectionIndex:&collectionIndex];
    if (local) {
        ETRCollectionModel *col = self.collections[collectionIndex];
        [col deleteItemAtIndexPath:local];
    }
}

- (NSString *)identifierForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath)
        return nil;
    NSInteger collectionIndex = 0;
    NSIndexPath* localPath = [self localIndexPathForGlobalIndexPath:indexPath
                                                    collectionIndex:&collectionIndex];
    if (!localPath)
        return nil;
    ETRCollectionModel *col = self.collections[collectionIndex];
    NSString* localId = [col identifierForItemAtIndexPath:localPath];
    if (!localId)
        return nil;
    return [NSString stringWithFormat:@"%ld/%@", (long)collectionIndex, localId];
}

- (NSIndexPath *)indexPathForItemWithIdentifier:(NSString *)identifier
{
    if (!identifier)
        return nil;
    NSInteger slashPos = [identifier rangeOfString:@"/"].location;
    if (slashPos == NSNotFound)
        return nil;
    NSInteger collectionIndex = [[identifier substringToIndex:slashPos] integerValue];
    if (collectionIndex < 0 || collectionIndex >= self.collections.count)
        return nil;
    ETRCollectionModel *col = self.collections[collectionIndex];
    NSString* localId = [identifier substringFromIndex:(slashPos + 1)];
    NSIndexPath* localPath = [col indexPathForItemWithIdentifier:localId];
    if (!localPath)
        return nil;
    return [self globalIndexPathForLocalIndexPath:localPath
                                  collectionIndex:collectionIndex];
}

@end
