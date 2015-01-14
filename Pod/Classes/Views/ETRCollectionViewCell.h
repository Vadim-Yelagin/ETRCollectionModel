//
//  ETRCollectionViewCell.h
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

@import UIKit;

@interface ETRCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) id viewModel;
@property (nonatomic, strong) IBOutlet UIView* backgroundView;
@property (nonatomic, strong) IBOutlet UIView* selectedBackgroundView;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray* dynamicHeightLabels;

@end
