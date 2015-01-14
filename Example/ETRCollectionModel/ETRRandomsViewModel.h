//
//  ETRRandomsViewModel.h
//  ETRCollectionModel
//
//  Created by Vadim Yelagin on 14/01/15.
//  Copyright (c) 2015 Vadim Yelagin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ETRCollectionModel/ETRAutoDiffCollectionModel.h>

@interface ETRRandomsViewModel : ETRAutoDiffCollectionModel

+ (instancetype)randomsViewModel;
- (void)refresh;

@end
