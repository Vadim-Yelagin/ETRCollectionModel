//
//  ETRReuseIdentifierMatching.h
//
//  Created by Vadim Yelagin on 10/02/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

@import Foundation;

@interface ETRReuseIdentifierMatching : NSObject

@property (nonatomic, copy) NSString* defaultReuseIdentifier;

- (void)registerReuseIdentifier:(NSString*)reuseIdentifier
                   forItemClass:(Class)itemClass;
- (void)registerReuseIdentifier:(NSString*)reuseIdentifier
                forItemMatching:(BOOL(^)(id item))matchingBlock;

- (NSString*)reuseIdentifierForItem:(id)item;

@end
