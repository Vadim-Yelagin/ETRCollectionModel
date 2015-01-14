//
//  ETRHidingCollectionModel.h
//
//  Created by Vadim Yelagin on 07/03/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCompositeCollectionModel.h"

@interface ETRHidingCollectionModel : ETRCompositeCollectionModel

@property (nonatomic, getter = isHidden) BOOL hidden;
@property (nonatomic, strong, readonly) ETRCollectionModel *collection;

- (instancetype)initWithCollection:(ETRCollectionModel *)collection NS_DESIGNATED_INITIALIZER;

@end
