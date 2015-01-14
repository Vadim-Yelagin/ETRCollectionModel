//
//  ETRCompositeCollectionModel.h
//
//  Created by Vadim Yelagin on 16/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionModel.h"

@interface ETRCompositeCollectionModel : ETRCollectionModel

@property (nonatomic, copy, readonly) NSArray* collections;
@property (nonatomic, strong, readonly) RACSignal* changes;

- (instancetype)initWithCollections:(NSArray*)collections NS_DESIGNATED_INITIALIZER;

- (NSIndexPath*)globalIndexPathForLocalIndexPath:(NSIndexPath*)indexPath
                                 collectionIndex:(NSInteger)collectionIndex;

- (NSIndexPath*)localIndexPathForGlobalIndexPath:(NSIndexPath*)indexPath
                                 collectionIndex:(NSInteger*)collectioIndexPtr;

- (NSInteger)globalSectionForLocalSection:(NSInteger)section
                          collectionIndex:(NSInteger)collectionIndex;

- (NSInteger)localSectionForGlobalSection:(NSInteger)section
                          collectionIndex:(NSInteger*)collectioIndexPtr;

- (BOOL)supportsSectionUpdates;

@end
