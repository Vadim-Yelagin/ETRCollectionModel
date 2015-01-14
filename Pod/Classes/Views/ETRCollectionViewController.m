//
//  ETRCollectionViewController.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChange.h"
#import "ETRCollectionModel.h"
#import "ETRCollectionViewCell.h"
#import "ETRCollectionViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ETRCollectionViewController

@synthesize reuseIdentifierMatching = _reuseIdentifierMatching;

- (void)handleChange:(ETRCollectionChange*)change
{
    if (self.isViewLoaded)
        [change updateCollectionView:self.collectionView];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    RACSignal* changes = [RACObserve(self, viewModel.changes) switchToLatest];
    [self rac_liftSelector:@selector(handleChange:) withSignals:changes, nil];
}

- (ETRReuseIdentifierMatching *)reuseIdentifierMatching
{
    if (!_reuseIdentifierMatching)
        _reuseIdentifierMatching = [[ETRReuseIdentifierMatching alloc] init];
    return _reuseIdentifierMatching;
}

- (void)setViewModel:(ETRCollectionModel *)viewModel
{
    _viewModel = viewModel;
    if (self.isViewLoaded)
        [self.collectionView reloadData];
}

#pragma mark UIViewController

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

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    id item = [self.viewModel itemAtIndexPath:indexPath];
    NSString *reuseIdentifier = [self.reuseIdentifierMatching reuseIdentifierForItem:item];
    ETRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                            forIndexPath:indexPath];
    cell.viewModel = item;
    return cell;
}

-   (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel didSelectItemAtIndexPath:indexPath completion:^{
        NSArray* sel = collectionView.indexPathsForSelectedItems;
        for (NSIndexPath* ip in sel) {
            [collectionView deselectItemAtIndexPath:ip
                                           animated:YES];
        }
    }];
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
