//
//  ETRCollectionChangeBatch.h
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"

@interface ETRCollectionChangeBatch : ETRCollectionChange

@property (nonatomic, strong) NSMutableArray* changes;

- (void)addChange:(ETRCollectionChange*)change;

@end
