//
//  ETRStaticCollectionSection.h
//
//  Created by Vadim Yelagin on 28/02/14.
//  Copyright (c) 2014 EastBanc Technologies Russia. All rights reserved.
//

@import UIKit;

@interface ETRStaticCollectionSection : NSObject

@property (nonatomic, copy, readonly) NSString* headerTitle;
@property (nonatomic, copy, readonly) NSString* footerTitle;
@property (nonatomic, copy, readonly) NSArray* items;

- (instancetype)initWithHeader:(NSString*)headerTitle
                        footer:(NSString*)footerTitle
                         items:(NSArray*)items NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithHeader:(NSString*)headerTitle
                         items:(NSArray*)items;

- (instancetype)initWithItems:(NSArray*)items;

+ (instancetype)sectionWithHeader:(NSString*)headerTitle
                           footer:(NSString*)footerTitle
                            items:(NSArray*)items;

+ (instancetype)sectionWithHeader:(NSString*)headerTitle
                            items:(NSArray*)items;

+ (instancetype)sectionWithItems:(NSArray*)items;

@end
