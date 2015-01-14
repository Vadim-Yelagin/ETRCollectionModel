//
//  ETRRelationshipCollectionModel.h
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionModel.h"

@interface ETRRelationshipCollectionModel : ETRCollectionModel

@property (nonatomic, strong, readonly) id target;
@property (nonatomic, copy, readonly) NSString* keyPath;
@property (nonatomic, copy, readonly) NSString* headerTitle;
@property (nonatomic, copy, readonly) NSString* footerTitle;
@property (nonatomic) BOOL allowDelete;

- (instancetype)initWithTarget:(id)target
                       keyPath:(NSString*)keyPath
                   headerTitle:(NSString*)headerTitle
                   footerTitle:(NSString*)footerTitle NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithTarget:(id)target
                       keyPath:(NSString*)keyPath
                   headerTitle:(NSString*)headerTitle;

- (instancetype)initWithTarget:(id)target
                       keyPath:(NSString*)keyPath;

@end
