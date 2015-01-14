//
//  ETRCarBrandsSearchResults.m
//
//  Created by Anton Kudryashov on 07.02.14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"
#import "ETRSearchResults.h"
#import "ETRTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ETRSearchResults

- (void)setFilteredViewModel:(ETRCollectionModel<ETRFilteredCollectionModel>*)filteredViewModel
{
    _filteredViewModel = filteredViewModel;
    [self.tableView reloadData];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    RACSignal* changes = [RACObserve(self, filteredViewModel.changes) switchToLatest];
    [self rac_liftSelector:@selector(handleChange:) withSignals:changes, nil];
}

- (void)handleChange:(ETRCollectionChange*)change
{
    [change updateTableView:self.tableView];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.filteredViewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredViewModel numberOfItemsInSection:section];
}

-  (NSString*)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return [self.filteredViewModel headerTitleForSection:section];
}

- (NSString*)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section
{
    return [self.filteredViewModel footerTitleForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier];
    cell.viewModel = [self.filteredViewModel itemAtIndexPath:indexPath];
    return cell;
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.filteredViewModel itemAtIndexPath:indexPath];
    [self.filteredViewModel didSelectItemAtIndexPath:indexPath completion:^{
        NSArray* sel = tableView.indexPathsForSelectedRows;
        for (NSIndexPath* ip in sel) {
            [tableView deselectRowAtIndexPath:ip
                                     animated:YES];
        }
    }];
    [self.delegate searchResults:self
              didSelectCellModel:item];
}

#pragma mark UISearchDisplayDelegate

- (void)searchDisplayController:(UISearchDisplayController *)controller
  didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:self.cellNibName
                                          bundle:nil]
    forCellReuseIdentifier:self.cellReuseIdentifier];
    self.tableView = tableView;
    if (self.tableFooterView) {
        self.tableView.tableFooterView = self.tableFooterView;
    }
    if ([self.delegate respondsToSelector:@selector(searchResults:didLoadTableView:)]) {
        [self.delegate searchResults:self didLoadTableView:tableView];
    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    if ([self.delegate respondsToSelector:@selector(searchResultsWillBeginSearch:)])
        [self.delegate searchResultsWillBeginSearch:self];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    if ([self.delegate respondsToSelector:@selector(searchResultsWillEndSearch:)])
        [self.delegate searchResultsWillEndSearch:self];
}

-  (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.filteredViewModel setSearchString:searchString];
    return NO;
}

@end
