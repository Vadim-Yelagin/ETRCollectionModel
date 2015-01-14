//
//  ETRStaticCellModel.h
//
//  Created by Vadim Yelagin on 11/07/14.
//

@import Foundation;

@interface ETRStaticCellModel : NSObject

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier NS_DESIGNATED_INITIALIZER;

@end
