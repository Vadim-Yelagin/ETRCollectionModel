//
//  ETRFetchedResultsCollectionModel.m
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionChangeBatch.h"
#import "ETRCollectionChangeSectionInsert.h"
#import "ETRCollectionChangeSectionDelete.h"
#import "ETRCollectionChangeItemInsert.h"
#import "ETRCollectionChangeItemDelete.h"
#import "ETRCollectionChangeReload.h"
#import "ETRFetchedResultsCollectionModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@import CoreData;

@interface ETRFetchedResultsCollectionModel () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) NSFetchedResultsController* frc;
@property (nonatomic, strong) ETRCollectionChangeBatch* changeBatch;

@end

@implementation ETRFetchedResultsCollectionModel
{
    RACSubject* _changes;
}

- (instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest
                managedObjectContext:(NSManagedObjectContext *)context
                  sectionNameKeyPath:(NSString *)sectionNameKeyPath
                           cacheName:(NSString *)name
{
    self = [super init];
    if (self) {
        _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                   managedObjectContext:context
                                                     sectionNameKeyPath:sectionNameKeyPath
                                                              cacheName:name];
        _frc.delegate = self;
        NSError *error = nil;
        if (![_frc performFetch:&error]) {
            NSLog(@"Error performing fetch %@", error);
            return nil;
        }
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFetchRequest:nil
                 managedObjectContext:nil
                   sectionNameKeyPath:nil
                            cacheName:nil];
}

- (NSString *)nameForSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return [sectionInfo name];
}

- (void)reloadData
{
    NSError *error = nil;
    if (![_frc performFetch:&error])
        NSLog(@"Error performing fetch %@", error);
    [_changes sendNext:[ETRCollectionChangeReload new]];
}

#pragma mark ETRCollectionModel

- (NSInteger)numberOfSections
{
    return self.frc.sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return sectionInfo.numberOfObjects;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.frc objectAtIndexPath:indexPath];
}

- (RACSignal*)changes
{
    if (!_changes)
        _changes = [RACSubject subject];
    return _changes;
}

- (BOOL)canDeleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.allowDelete;
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject* item = [self.frc objectAtIndexPath:indexPath];
    NSManagedObjectContext* moc = self.frc.managedObjectContext;
    [moc deleteObject:item];
}

- (NSString *)headerTitleForSection:(NSInteger)section
{
    return [self.frc.sections[section] name];
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.changeBatch = [[ETRCollectionChangeBatch alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.changeBatch addChange:[[ETRCollectionChangeSectionInsert alloc] initWithSection:sectionIndex]];
            break;
        case NSFetchedResultsChangeDelete:
            [self.changeBatch addChange:[[ETRCollectionChangeSectionDelete alloc] initWithSection:sectionIndex]];
            break;
        default:
            // other values not used for sections
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.changeBatch addChange:[[ETRCollectionChangeItemInsert alloc] initWithIndexPath:newIndexPath]];
            break;
        case NSFetchedResultsChangeDelete:
            [self.changeBatch addChange:[[ETRCollectionChangeItemDelete alloc] initWithIndexPath:indexPath]];
            break;
        case NSFetchedResultsChangeMove:
            [self.changeBatch addChange:[[ETRCollectionChangeItemDelete alloc] initWithIndexPath:indexPath]];
            [self.changeBatch addChange:[[ETRCollectionChangeItemInsert alloc] initWithIndexPath:newIndexPath]];
            break;
        case NSFetchedResultsChangeUpdate:
            // cell is supposed to update via KVO
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.changeBatch.changes.count)
        [_changes sendNext:self.changeBatch];
    self.changeBatch = nil;
}

- (NSString *)identifierForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath)
        return nil;
    NSManagedObject* mo = [self.frc objectAtIndexPath:indexPath];
    return mo.objectID.URIRepresentation.absoluteString;
}

- (NSIndexPath *)indexPathForItemWithIdentifier:(NSString *)identifier
{
    if (!identifier)
        return nil;
    NSURL* url = [NSURL URLWithString:identifier];
    if (![url.scheme isEqualToString:@"x-coredata"])
        return nil;
    NSManagedObjectContext* moc = self.frc.managedObjectContext;
    NSManagedObjectID* moid = [moc.persistentStoreCoordinator managedObjectIDForURIRepresentation:url];
    if (!moid)
        return nil;
    NSManagedObject* obj = [moc existingObjectWithID:moid error:nil];
    if (!obj)
        return nil;
    return [self.frc indexPathForObject:obj];
}

@end
