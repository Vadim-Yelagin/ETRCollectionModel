//
//  ETRCollectionModel.m
//  Ingosstrakh-iOS
//
//  Created by Vadim Yelagin on 14/10/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ETRCollectionModel

- (RACSignal *)changes
{
    return [RACSignal empty];
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

- (void)didSelectItemAtIndexPath:(NSIndexPath*)indexPath
                      completion:(void(^)(void))completion
{
}

- (BOOL)canDeleteItemAtIndexPath:(NSIndexPath*)indexPath
{
    return NO;
}

- (void)deleteItemAtIndexPath:(NSIndexPath*)indexPath
{
}

- (NSString*)identifierForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

- (NSIndexPath*)indexPathForItemWithIdentifier:(NSString*)identifier
{
    return nil;
}

- (NSString*)headerTitleForSection:(NSInteger)section
{
    return nil;
}

- (NSString*)footerTitleForSection:(NSInteger)section
{
    return nil;
}

@end
