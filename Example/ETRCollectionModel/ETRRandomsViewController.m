//
//  ETRRandomsViewController.m
//  ETRCollectionModel
//
//  Created by Vadim Yelagin on 14/01/15.
//  Copyright (c) 2015 Vadim Yelagin. All rights reserved.
//

#import "ETRRandomsViewController.h"

@implementation ETRRandomsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.reuseIdentifierMatching.defaultReuseIdentifier = @"ETRRandomsCell";
    self.viewModel = [ETRRandomsViewModel randomsViewModel];
}

- (IBAction)refresh
{
    [self.viewModel refresh];
}

@end
