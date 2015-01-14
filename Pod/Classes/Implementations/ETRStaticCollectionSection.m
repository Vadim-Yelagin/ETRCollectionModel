//
//  ETRStaticCollectionSection.m
//
//  Created by Vadim Yelagin on 28/02/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRStaticCollectionSection.h"

@implementation ETRStaticCollectionSection

- (instancetype)initWithHeader:(NSString *)headerTitle
                        footer:(NSString *)footerTitle
                         items:(NSArray *)items
{
    self = [super init];
    if (self) {
        _headerTitle = [headerTitle copy];
        _footerTitle = [footerTitle copy];
        _items = [items copy];
    }
    return self;
}

- (instancetype)initWithHeader:(NSString *)headerTitle
                         items:(NSArray *)items
{
    return [self initWithHeader:headerTitle
                         footer:nil
                          items:items];
}

- (instancetype)initWithItems:(NSArray *)items
{
    return [self initWithHeader:nil
                         footer:nil
                          items:items];
}

- (instancetype)init
{
    return [self initWithHeader:nil
                         footer:nil
                          items:nil];
}

+ (instancetype)sectionWithHeader:(NSString*)headerTitle
                           footer:(NSString *)footerTitle
                            items:(NSArray*)items
{
    return [[self alloc] initWithHeader:headerTitle
                                 footer:footerTitle
                                  items:items];
}

+ (instancetype)sectionWithHeader:(NSString *)headerTitle
                            items:(NSArray *)items
{
    return [[self alloc] initWithHeader:headerTitle
                                  items:items];
}

+ (instancetype)sectionWithItems:(NSArray*)items
{
    return [[self alloc] initWithItems:items];
}

@end
