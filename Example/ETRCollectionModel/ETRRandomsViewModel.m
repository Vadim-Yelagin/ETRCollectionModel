//
//  ETRRandomsViewModel.m
//  ETRCollectionModel
//
//  Created by Vadim Yelagin on 14/01/15.
//  Copyright (c) 2015 Vadim Yelagin. All rights reserved.
//

#import "ETRRandomsViewModel.h"

@implementation ETRRandomsViewModel

+ (NSArray *)generateRandomItems
{
    NSMutableArray* items = [NSMutableArray array];
    NSInteger n = 6 + arc4random_uniform(4);
    NSInteger k = 127;
    for (NSInteger i = 0; i < n; i++) {
        NSInteger rnd = (1 + arc4random_uniform(6)) * k;
        [items addObject:@(rnd)];
    }
    return items;
}

+ (instancetype)randomsViewModel
{
    return [[self alloc] initWithItems:[self generateRandomItems]];
}

- (void)refresh
{
    self.items = [[self class] generateRandomItems];
}

@end
