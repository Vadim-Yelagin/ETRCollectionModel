//
//  ETRProxyCollectionModel.h
//
//  Created by Vadim Yelagin on 12/05/14.
//  Copyright (c) 2014 EastBanc IT. All rights reserved.
//

#import "ETRCollectionModel.h"

@interface ETRProxyCollectionModel : ETRCollectionModel

@property (nonatomic, strong) ETRCollectionModel *collection;
@property (nonatomic, strong, readonly) RACSignal* changes;

@end
