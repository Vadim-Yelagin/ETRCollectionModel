//
//  ETRStaticCollectionModel.h
//
//  Created by Vadim Yelagin on 16/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionModel.h"

@interface ETRStaticCollectionModel : ETRCollectionModel

@property (nonatomic, copy) NSArray* sections;

- (instancetype)initWithSections:(NSArray*)sections NS_DESIGNATED_INITIALIZER;

@end
