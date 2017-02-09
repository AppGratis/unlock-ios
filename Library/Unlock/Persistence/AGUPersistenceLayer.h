//
//  AGUPersistenceLayer.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGURedeemedFeature.h"
#import "AGUOffer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AGUPersistenceLayer <NSObject>

@required
- (NSArray<AGURedeemedFeature*>*)availableFeatures;

- (void)deleteFeatures:(NSArray<AGUFeature*>*)features;

- (void)wipe;

- (void)markOfferAsConsumed:(AGUOffer*)offer;

- (void)markRepeatingOfferAsConsumed:(AGUOffer*)offer forDate:(NSDate*)date;

- (void)saveFeature:(AGUFeature*)feature;

- (BOOL)isOfferTokenConsumed:(NSString*)offerToken;

- (BOOL)isRepeatingOfferTokenConsumed:(NSString*)offerToken forDay:(NSDate*)day;

@end

NS_ASSUME_NONNULL_END
