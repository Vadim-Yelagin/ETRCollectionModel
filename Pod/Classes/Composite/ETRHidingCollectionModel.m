//
//  ETRHidingCollectionModel.m
//  Ingosstrakh-iOS
//
//  Created by Vadim Yelagin on 07/03/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"
#import "ETRCollectionChangeBatch.h"
#import "ETRCollectionChangeSectionDelete.h"
#import "ETRCollectionChangeSectionInsert.h"
#import "ETRHidingCollectionModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ETRHidingCollectionModel ()

@property (nonatomic, strong) RACSignal* outputChanges;

@end

@implementation ETRHidingCollectionModel

- (instancetype)initWithCollection:(ETRCollectionModel *)collection
{
    self = [super initWithCollections:@[collection]];
    if (self) {
        RACSignal* hiddenChanges = [[[RACObserve(self, hidden)
                                      distinctUntilChanged]
                                     skip:1]
                                    map:^ETRCollectionChange*(NSNumber* value) {
                                        ETRCollectionChangeBatch* batch = [[ETRCollectionChangeBatch alloc] init];
                                        NSInteger sections = [collection numberOfSections];
                                        for (NSInteger section = 0; section < sections; section++) {
                                            ETRCollectionChange* change = value.boolValue
                                            ? [[ETRCollectionChangeSectionDelete alloc] initWithSection:section]
                                            : [[ETRCollectionChangeSectionInsert alloc] initWithSection:section];
                                            [batch addChange:change];
                                        }
                                        return batch;
                                    }];
        RACSignal* originalChanges = [super changes];
        RACSignal* filteredChanges = [[self rac_liftSelector:@selector(filterChange:)
                                                 withSignals:originalChanges, nil]
                                      ignore:nil];
        _outputChanges = [RACSignal merge:@[hiddenChanges, filteredChanges]];
    }
    return self;
}

- (instancetype)initWithCollections:(NSArray *)collections
{
    return [self initWithCollection:collections.firstObject];
}

- (ETRCollectionModel *)collection
{
    return self.collections.firstObject;
}

- (RACSignal *)changes
{
    return self.outputChanges;
}

- (ETRCollectionChange*)filterChange:(ETRCollectionChange*)change
{
    return self.hidden ? nil : change;
}

- (BOOL)supportsSectionUpdates
{
    return YES;
}

- (NSInteger)numberOfSections
{
    return self.hidden ? 0 : [self.collection numberOfSections];
}

@end
