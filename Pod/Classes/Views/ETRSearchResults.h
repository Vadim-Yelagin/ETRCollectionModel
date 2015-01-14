//
//  ETRSearchResults.h
//
//  Created by Anton Kudryashov on 07.02.14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionModel.h"
#import "ETRFilteredCollectionModel.h"

@class ETRCollectionChange;
@protocol ETRSearchResultsDelegate;

@interface ETRSearchResults : NSObject <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) ETRCollectionModel<ETRFilteredCollectionModel>* filteredViewModel;
@property (nonatomic, weak) IBOutlet id<ETRSearchResultsDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString* cellNibName;
@property (nonatomic, copy) NSString* cellReuseIdentifier;
@property (nonatomic, strong) IBOutlet UIView* tableFooterView;

- (void)handleChange:(ETRCollectionChange*)change;

@end

@protocol ETRSearchResultsDelegate <NSObject>

- (void)searchResults:(ETRSearchResults*)searchResults
   didSelectCellModel:(id)cellModel;

@optional

- (void)searchResultsWillBeginSearch:(ETRSearchResults*)searchResults;

- (void)searchResultsWillEndSearch:(ETRSearchResults*)searchResults;

- (void)searchResults:(ETRSearchResults*)searchResults
     didLoadTableView:(UITableView*)tableView;

@end
