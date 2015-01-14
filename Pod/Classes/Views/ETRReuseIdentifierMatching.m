//
//  ETRReuseIdentifierMatching.m
//
//  Created by Vadim Yelagin on 10/02/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRReuseIdentifierMatching.h"

@interface ETRItemMatching : NSObject

@property (nonatomic, copy) NSString* reuseIdentifier;
@property (nonatomic, copy) BOOL (^matchingBlock)(id);

@end

@implementation ETRItemMatching

@end

@interface ETRReuseIdentifierMatching ()

@property (nonatomic, strong) NSMutableArray* itemMatchings;

@end

@implementation ETRReuseIdentifierMatching

- (void)registerReuseIdentifier:(NSString *)reuseIdentifier
                forItemMatching:(BOOL (^)(id))matchingBlock
{
    ETRItemMatching* matching = [ETRItemMatching new];
    matching.reuseIdentifier = reuseIdentifier;
    matching.matchingBlock = matchingBlock;
    if (self.itemMatchings) {
        [self.itemMatchings addObject:matching];
    } else {
        self.itemMatchings = [NSMutableArray arrayWithObject:matching];
    }
}

- (void)registerReuseIdentifier:(NSString *)reuseIdentifier
                   forItemClass:(Class)itemClass
{
    [self registerReuseIdentifier:reuseIdentifier
                  forItemMatching:^BOOL(id item) {
                      return [item isKindOfClass:itemClass];
                  }];
}

- (NSString*)reuseIdentifierForItem:(id)item
{
    if ([item respondsToSelector:@selector(reuseIdentifier)])
        return [item reuseIdentifier];
    for (ETRItemMatching* matching in self.itemMatchings) {
        if (matching.matchingBlock(item))
            return matching.reuseIdentifier;
    }
    return self.defaultReuseIdentifier;
}

@end
