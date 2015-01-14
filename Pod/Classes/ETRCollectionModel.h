//
//  ETRCollectionModel.h
//
//  Created by Vadim Yelagin on 14/10/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

@import Foundation;

@class RACSignal;

@interface ETRCollectionModel : NSObject

@property (nonatomic, readonly, strong) RACSignal* changes;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (id)itemAtIndexPath:(NSIndexPath*)indexPath;
- (void)didSelectItemAtIndexPath:(NSIndexPath*)indexPath
                      completion:(void(^)(void))completion;
- (BOOL)canDeleteItemAtIndexPath:(NSIndexPath*)indexPath;
- (void)deleteItemAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)identifierForItemAtIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)indexPathForItemWithIdentifier:(NSString*)identifier;
- (NSString*)headerTitleForSection:(NSInteger)section;
- (NSString*)footerTitleForSection:(NSInteger)section;

@end
