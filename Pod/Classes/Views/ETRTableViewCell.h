//
//  ETRTableViewCell.h
//
//  Created by Vadim Yelagin on 10/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

@import UIKit;

@class ETRTableViewController;

@interface ETRTableViewCell : UITableViewCell

@property (nonatomic, weak) ETRTableViewController *tableViewController;
@property (nonatomic, strong) id viewModel;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray* dynamicHeightLabels;

@end
