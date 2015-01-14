//
//  ETRRandomsCell.m
//  ETRCollectionModel
//
//  Created by Vadim Yelagin on 14/01/15.
//  Copyright (c) 2015 Vadim Yelagin. All rights reserved.
//

#import "ETRRandomsCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ETRRandomsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    static NSNumberFormatter* nf = nil;
    if (!nf) {
        nf = [[NSNumberFormatter alloc] init];
        nf.numberStyle = NSNumberFormatterSpellOutStyle;
    }
    RAC(self.textLabel, text) = [RACObserve(self, viewModel)
                                 map:^NSString *(NSNumber *value)
                                 {
                                     return [nf stringFromNumber:value];
                                 }];
}

@end
