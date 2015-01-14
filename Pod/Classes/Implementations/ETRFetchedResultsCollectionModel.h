//
//  ETRFetchedResultsCollectionModel.h
//
//  Created by Vadim Yelagin on 15/01/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

#import "ETRCollectionModel.h"

@class NSFetchedResultsController;
@class NSFetchRequest;
@class NSManagedObjectContext;

@interface ETRFetchedResultsCollectionModel : ETRCollectionModel

@property (nonatomic, strong, readonly) NSFetchedResultsController* frc;
@property (nonatomic) BOOL allowDelete;

- (instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest
                managedObjectContext:(NSManagedObjectContext *)context
                  sectionNameKeyPath:(NSString *)sectionNameKeyPath
                           cacheName:(NSString *)name NS_DESIGNATED_INITIALIZER;

- (NSString*)nameForSection:(NSInteger)section;

- (void)reloadData;

@end
