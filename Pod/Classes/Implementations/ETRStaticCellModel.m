//
//  ETRStaticCellModel.m
//
//  Created by Vadim Yelagin on 11/07/14.
//

#import "ETRStaticCellModel.h"

@implementation ETRStaticCellModel

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        _reuseIdentifier = [reuseIdentifier copy];
    }
    return self;
}

@end
