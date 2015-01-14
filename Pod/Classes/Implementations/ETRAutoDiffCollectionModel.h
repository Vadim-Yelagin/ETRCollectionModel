//
//  ETRAutoDiffCollectionModel.h
//
//  Created by Vadim Yelagin on 20/03/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionModel.h"

@interface ETRAutoDiffCollectionModel : ETRCollectionModel

@property (nonatomic, copy, readonly) NSString* headerTitle;
@property (nonatomic, copy, readonly) NSString* footerTitle;
@property (nonatomic, copy) NSArray* items;

- (instancetype)initWithItems:(NSArray*)items NS_DESIGNATED_INITIALIZER;

- (BOOL)isItem:(id)item1
    sameAsItem:(id)item2;

@end
