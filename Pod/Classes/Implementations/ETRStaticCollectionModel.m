//
//  ETRStaticCollectionModel.m
//
//  Created by Vadim Yelagin on 16/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeReload.h"
#import "ETRStaticCollectionModel.h"
#import "ETRStaticCollectionSection.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString* NSStringFromNSIndexPath(NSIndexPath* indexPath)
{
    NSMutableArray* indices = [NSMutableArray array];
    for (NSInteger i = 0; i < indexPath.length; i++) {
        NSUInteger index = [indexPath indexAtPosition:i];
        [indices addObject:@(index).stringValue];
    }
    return [indices componentsJoinedByString:@"/"];
}

static NSIndexPath* NSIndexPathFromNSString(NSString* string)
{
    NSArray* indices = [string componentsSeparatedByString:@"/"];
    NSUInteger* uhoh = malloc(sizeof(NSUInteger) * indices.count);
    NSInteger i = 0;
    for (NSString* index in indices) {
        uhoh[i++] = [index integerValue];
    }
    NSIndexPath* res = [NSIndexPath indexPathWithIndexes:uhoh length:indices.count];
    free(uhoh); uhoh = NULL;
    return res;
}

@implementation ETRStaticCollectionModel

@synthesize changes = _changes;

- (instancetype)initWithSections:(NSArray *)sections
{
    self = [super init];
    if (self) {
        _changes = [RACObserve(self, sections) map:^id(id value) {
            return [[ETRCollectionChangeReload alloc] init];
        }];
        _sections = sections;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithSections:nil];
}

- (NSInteger)numberOfSections
{
    return self.sections.count;
}

- (NSArray*)itemsInSection:(NSInteger)section
{
    id sec = self.sections[section];
    if ([sec isKindOfClass:[NSArray class]])
        return sec;
    if ([sec isKindOfClass:[ETRStaticCollectionSection class]])
        return [sec items];
    return nil;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    NSArray* items = [self itemsInSection:section];
    return items.count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* items = [self itemsInSection:indexPath.section];
    return items[indexPath.item];
}

- (NSString *)headerTitleForSection:(NSInteger)section
{
    id sec = self.sections[section];
    if ([sec isKindOfClass:[ETRStaticCollectionSection class]])
        return [sec headerTitle];
    return nil;
}

- (NSString *)footerTitleForSection:(NSInteger)section
{
    id sec = self.sections[section];
    if ([sec isKindOfClass:[ETRStaticCollectionSection class]])
        return [sec footerTitle];
    return nil;
}

- (NSString *)identifierForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NSStringFromNSIndexPath(indexPath);
}

- (NSIndexPath *)indexPathForItemWithIdentifier:(NSString *)identifier
{
    NSIndexPath* indexPath = NSIndexPathFromNSString(identifier);
    if (indexPath.length != 2)
        return nil;
    if (indexPath.section < 0 || indexPath.section >= self.sections.count)
        return nil;
    NSArray* items = self.sections[indexPath.section];
    if (indexPath.row < 0 || indexPath.row >= items.count)
        return nil;
    return indexPath;
}

@end
