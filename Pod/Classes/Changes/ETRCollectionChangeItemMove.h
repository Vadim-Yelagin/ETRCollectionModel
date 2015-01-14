//
//  ETRCollectionChangeItemMove.h
//
//  Created by Vadim Yelagin on 21/03/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"

@interface ETRCollectionChangeItemMove : ETRCollectionChange

- (instancetype)initWithFromIndexPath:(NSIndexPath*)fromIndexPath
                          toIndexPath:(NSIndexPath*)toIndexPath NS_DESIGNATED_INITIALIZER;

@end
