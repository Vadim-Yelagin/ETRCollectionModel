//
//  ETRTableViewController.h
//
//  Created by Vadim Yelagin on 13/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRReuseIdentifierMatching.h"

@import UIKit;

extern CGFloat const ETRStaticRowHeight;
extern CGFloat const ETRDynamicRowHeight;

@class ETRCollectionChange;
@class ETRCollectionModel;

@interface ETRTableViewController : UITableViewController <UIDataSourceModelAssociation>

@property (nonatomic, strong) ETRCollectionModel *viewModel;
@property (nonatomic, strong, readonly) ETRReuseIdentifierMatching* reuseIdentifierMatching;
@property (nonatomic) BOOL disableViewModelRestoration;

- (void)handleChange:(ETRCollectionChange*)change;
- (void)invalidateStaticRowHeights;
- (CGFloat)rowHeightForItem:(id)item;

@end
