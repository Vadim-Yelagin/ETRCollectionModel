//
//  ETRCollectionViewCell.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionViewCell.h"

@implementation ETRCollectionViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutSubviews];
    BOOL fixed = NO;
    for (UILabel* label in self.dynamicHeightLabels) {
        CGFloat w = label.bounds.size.width;
        if (label.preferredMaxLayoutWidth != w) {
            label.preferredMaxLayoutWidth = w;
            fixed = YES;
        }
    }
    if (fixed)
        [super layoutSubviews];
}

@end
