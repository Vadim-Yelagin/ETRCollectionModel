//
//  ETRCollectionChangeSections.h
//
//  Created by Vadim Yelagin on 14/10/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"

@interface ETRCollectionChangeSections : ETRCollectionChange

@property (nonatomic, copy, readonly) NSIndexSet *sections;

- (instancetype)initWithSection:(NSInteger)section;
- (instancetype)initWithSections:(NSIndexSet*)sections NS_DESIGNATED_INITIALIZER;

@end
