//
//  ETRCollectionViewController.h
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRReuseIdentifierMatching.h"

@import UIKit;

@class ETRCollectionModel;

@interface ETRCollectionViewController : UICollectionViewController <UIDataSourceModelAssociation>

@property (nonatomic, strong) ETRCollectionModel *viewModel;
@property (nonatomic, strong, readonly) ETRReuseIdentifierMatching* reuseIdentifierMatching;
@property (nonatomic) BOOL disableViewModelRestoration;

@end
