//
//  ETRRandomsViewController.h
//  ETRCollectionModel
//
//  Created by Vadim Yelagin on 14/01/15.
//  Copyright (c) 2015 Vadim Yelagin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ETRCollectionModel/ETRTableViewController.h>
#import "ETRRandomsViewModel.h"

@interface ETRRandomsViewController : ETRTableViewController

@property (nonatomic, strong) ETRRandomsViewModel *viewModel;

@end
