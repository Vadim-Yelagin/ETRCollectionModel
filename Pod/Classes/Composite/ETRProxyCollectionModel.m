//
//  ETRProxyCollectionModel.m
//
//  Created by Vadim Yelagin on 12/05/14.
//  Copyright (c) 2014 EastBanc IT. All rights reserved.
//

#import "ETRCollectionChangeReload.h"
#import "ETRProxyCollectionModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ETRProxyCollectionModel

@synthesize changes = _changes;

- (instancetype)init
{
    self = [super init];
    if (self) {
        RACSignal* inner = [RACObserve(self, collection.changes) switchToLatest];
        RACSignal* outer = [RACObserve(self, collection) map:^id(id value) {
            return [[ETRCollectionChangeReload alloc] init];
        }];
        _changes = [RACSignal merge:@[inner, outer]];
    }
    return self;
}

- (NSInteger)numberOfSections
{
    return [self.collection numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.collection numberOfItemsInSection:section];
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.collection itemAtIndexPath:indexPath];
}

- (void)didSelectItemAtIndexPath:(NSIndexPath*)indexPath
                      completion:(void(^)(void))completion
{
    [self.collection didSelectItemAtIndexPath:indexPath completion:completion];
}

- (BOOL)canDeleteItemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.collection canDeleteItemAtIndexPath:indexPath];
}

- (void)deleteItemAtIndexPath:(NSIndexPath*)indexPath
{
    [self.collection deleteItemAtIndexPath:indexPath];
}

- (NSString*)identifierForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.collection identifierForItemAtIndexPath:indexPath];
}

- (NSIndexPath*)indexPathForItemWithIdentifier:(NSString*)identifier
{
    return [self.collection indexPathForItemWithIdentifier:identifier];
}

- (NSString*)headerTitleForSection:(NSInteger)section
{
    return [self.collection headerTitleForSection:section];
}

- (NSString*)footerTitleForSection:(NSInteger)section
{
    return [self.collection footerTitleForSection:section];
}

@end
