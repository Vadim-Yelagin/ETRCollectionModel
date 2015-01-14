//
//  ETRTableViewController.m
//
//  Created by Vadim Yelagin on 13/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"
#import "ETRCollectionModel.h"
#import "ETRTableViewCell.h"
#import "ETRTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

CGFloat const ETRStaticRowHeight = -1;
CGFloat const ETRDynamicRowHeight = -2;

@interface ETRTableViewController ()

@property (nonatomic, strong) NSMutableDictionary* prototypeCells;
@property (nonatomic, strong) NSMutableDictionary* staticHeights;
@property (nonatomic, copy) NSArray* indexPathsOfCellsDeselectedOnBack;

@end

@implementation ETRTableViewController

@synthesize reuseIdentifierMatching = _reuseIdentifierMatching;

- (void)handleChange:(ETRCollectionChange*)change
{
    self.indexPathsOfCellsDeselectedOnBack = nil;
    if (self.isViewLoaded)
        [change updateTableView:self.tableView];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    RACSignal* changes = [RACObserve(self, viewModel.changes) switchToLatest];
    [self rac_liftSelector:@selector(handleChange:) withSignals:changes, nil];
}

- (void)setViewModel:(ETRCollectionModel *)viewModel
{
    self.indexPathsOfCellsDeselectedOnBack = nil;
    _viewModel = viewModel;
    if (self.isViewLoaded)
        [self.tableView reloadData];
}

- (void)invalidateStaticRowHeights
{
    self.staticHeights = nil;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (ETRReuseIdentifierMatching *)reuseIdentifierMatching
{
    if (!_reuseIdentifierMatching)
        _reuseIdentifierMatching = [[ETRReuseIdentifierMatching alloc] init];
    return _reuseIdentifierMatching;
}

- (ETRTableViewCell*)prototypeCellWithReuseIdentifier:(NSString*)reuseIdentifier
{
    ETRTableViewCell* cell = self.prototypeCells[reuseIdentifier];
    if (!cell) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if (self.prototypeCells) {
            self.prototypeCells[reuseIdentifier] = cell;
        } else {
            self.prototypeCells = [NSMutableDictionary dictionaryWithObject:cell
                                                                     forKey:reuseIdentifier];
        }
    }
    return cell;
}

- (CGFloat)staticRowHeightForItem:(id)item
{
    NSString *reuseIdentifier = [self.reuseIdentifierMatching reuseIdentifierForItem:item];
    NSNumber *height = self.staticHeights[reuseIdentifier];
    if (!height) {
        height = @([self calculateRowHeightForItem:item]);
        if (self.staticHeights) {
            self.staticHeights[reuseIdentifier] = height;
        } else {
            self.staticHeights = [NSMutableDictionary dictionaryWithObject:height
                                                                    forKey:reuseIdentifier];
        }
    }
    return height.floatValue;
}

- (CGFloat)calculateRowHeightForItem:(id)item
{
    NSString *reuseIdentifier = [self.reuseIdentifierMatching reuseIdentifierForItem:item];
    ETRTableViewCell* cell = [self prototypeCellWithReuseIdentifier:reuseIdentifier];
    cell.viewModel = item;
    CGRect frame = cell.frame;
    frame.size.width = self.tableView.bounds.size.width;
    cell.frame = frame;
    [cell layoutIfNeeded];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)rowHeightForItem:(id)item
{
    return self.tableView.rowHeight;
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.clearsSelectionOnViewWillAppear) {
        NSArray* sel = self.tableView.indexPathsForSelectedRows;
        for (NSIndexPath* ip in sel) {
            [self.tableView deselectRowAtIndexPath:ip
                                          animated:animated];
        }
        self.indexPathsOfCellsDeselectedOnBack = sel;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.indexPathsOfCellsDeselectedOnBack = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSArray* sel = self.indexPathsOfCellsDeselectedOnBack;
    for (NSIndexPath* ip in sel) {
        if (ip.section < self.tableView.numberOfSections &&
            ip.row < [self.tableView numberOfRowsInSection:ip.section])
        {
            [self.tableView selectRowAtIndexPath:ip
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
        }
    }
    self.indexPathsOfCellsDeselectedOnBack = nil;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    if ([self.viewModel conformsToProtocol:@protocol(NSCoding)] &&
        !self.disableViewModelRestoration)
    {
        [coder encodeObject:self.viewModel forKey:@"viewModel"];
    }
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    if (!self.disableViewModelRestoration)
        self.viewModel = [coder decodeObjectForKey:@"viewModel"] ?: self.viewModel;
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection:section];
}

-  (NSString*)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return [self.viewModel headerTitleForSection:section];
}

- (NSString*)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section
{
    return [self.viewModel footerTitleForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.viewModel itemAtIndexPath:indexPath];
    NSString *reuseIdentifier = [self.reuseIdentifierMatching reuseIdentifierForItem:item];
    ETRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                             forIndexPath:indexPath];
    cell.tableViewController = self;
    cell.viewModel = item;
    return cell;
}

-    (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.viewModel itemAtIndexPath:indexPath];
    CGFloat height = [self rowHeightForItem:item];
    if (height == ETRDynamicRowHeight) {
        height = [self calculateRowHeightForItem:item];
    } else if (height == ETRStaticRowHeight) {
        height = [self staticRowHeightForItem:item];
    }
    return height;
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel didSelectItemAtIndexPath:indexPath completion:^{
        NSArray* sel = tableView.indexPathsForSelectedRows;
        for (NSIndexPath* ip in sel) {
            [tableView deselectRowAtIndexPath:ip
                                     animated:YES];
        }
    }];
}

-     (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.viewModel canDeleteItemAtIndexPath:indexPath];
}

-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
            [self.viewModel deleteItemAtIndexPath:indexPath];
            break;
        default:
            break;
    }
}

#pragma mark UIDataSourceModelAssociation

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)indexPath
                                            inView:(UIView *)view
{
    return [self.viewModel identifierForItemAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier
                                                 inView:(UIView *)view
{
    return [self.viewModel indexPathForItemWithIdentifier:identifier];
}

@end
