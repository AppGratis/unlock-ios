//
//  AGUUnlockManager.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUUnlockManager.h"

#import "AGUPersistenceLayer.h"
#import "AGUDateProvider.h"
#import "AGUSystemDateProvider.h"
#import "AGUSqlitePersistenceLayer.h"
#import "AGUDatasourceParser.h"

#import "AGUFeatureInternal.h"

@interface AGUUnlockManager ()
{
    id<AGUPersistenceLayer> _persistenceLayer;
    id<AGUDateProvider> _dateProvider;
    
    NSArray<AGUOffer*> *_offers;
}
@end

@implementation AGUUnlockManager

+ (instancetype _Nullable)managerForOfferSource:(id<AGUOfferSource> _Nonnull)offerSource error:(NSError** _Nullable)error
{
    return [[AGUUnlockManager alloc] initWithOfferSource:offerSource
                                        persistenceLayer:[AGUSqlitePersistenceLayer new]
                                            dateProvider:[AGUSystemDateProvider new]
                                                   error:error];
}

- (instancetype _Nullable)initWithOfferSource:(id<AGUOfferSource> _Nonnull)offerSource
                             persistenceLayer:(id<AGUPersistenceLayer> _Nonnull)persistenceLayer
                                 dateProvider:(id<AGUDateProvider> _Nonnull)dateProvider
                                        error:(NSError** _Nullable)outError
{
    self = [super init];
    if (self) {
        _persistenceLayer = persistenceLayer;
        _dateProvider = dateProvider;
        
        NSError *err = nil;
        _offers = [AGUDatasourceParser parseJSONString:[offerSource offersJSON] error:&err];
        
        if (outError) {
            *outError = err;
        }
        
        if (err) {
            return nil;
        }
    }
    return self;
}

- (NSArray<AGUFeature*>*)features
{
    NSMutableArray<AGUFeature*> *features = [NSMutableArray new];
    NSMutableArray<AGUFeature*> *expiredFeatures = [NSMutableArray new];
    NSArray<AGURedeemedFeature*> *availableFeatures = [_persistenceLayer availableFeatures];
    
    NSDate *currentDate = [_dateProvider currentDate];
    
    for (AGURedeemedFeature *availableFeature in availableFeatures) {
        AGUFeature *feature = availableFeature.feature;
        [feature updateRemainingLifetimeForDate:currentDate redeemDate:availableFeature.redeemDate];
        if (!feature.isExpired) {
            [features addObject:feature];
        } else {
            [expiredFeatures addObject:feature];
        }
    }
    
    [_persistenceLayer deleteFeatures:expiredFeatures];
    return features;
}

- (NSArray<AGUOffer*>*)pendingOffers
{
    NSMutableArray<AGUOffer*>* pendingOffers = [NSMutableArray new];
    
    for (AGUOffer *offer in _offers) {
        if (offer.isRepeating) {
            if ([_persistenceLayer isRepeatingOfferTokenConsumed:offer.token forDay:[_dateProvider currentDate]]) {
                continue;
            }
        } else {
            if ([_persistenceLayer isOfferTokenConsumed:offer.token]) {
                continue;
            }
        }
        
        if ([offer.conditions isSatisfied:_dateProvider]) {
            //TODO: Make a deep copy of the offer
            [pendingOffers addObject:offer];
        }
    }
    
    return pendingOffers;
}

- (void)addOffer:(AGUOffer*)offer
{
    if (_offers == nil) {
        _offers = @[];
    }
    _offers = [_offers arrayByAddingObject:offer];
}

- (NSArray<AGUOffer*>*)offers
{
    return [_offers copy];
}

- (void)consumeOffer:(nonnull AGUOffer*)offer
{
    if (offer.isRepeating) {
        [_persistenceLayer markRepeatingOfferAsConsumed:offer forDate:[_dateProvider currentDate]];
    } else {
        [_persistenceLayer markOfferAsConsumed:offer];
    }
    
    // Only save a feature if it won't be overwrite a lifetime unlocked one with a limited TTL one
    for (AGUFeature *feature in offer.features) {
        if (feature.isTimeLimited) {
            for (AGURedeemedFeature *availableFeature in [_persistenceLayer availableFeatures]) {
                if (!availableFeature.feature.isTimeLimited && feature.name && [feature.name caseInsensitiveCompare:availableFeature.feature.name] == NSOrderedSame) {
                    // Don't overwrite the feature: jump at the outer loop's end
                    goto continueFeatureLoop;
                }
            }
        }
        
        [_persistenceLayer saveFeature:feature];
        continueFeatureLoop:;
    }
}

- (void)wipeData
{
    [_persistenceLayer wipe];
}

@end
