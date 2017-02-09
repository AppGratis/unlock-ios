//
//  MockPersistenceLayer.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "MockPersistenceLayer.h"

@interface MockPersistenceLayer ()
{
    id<AGUDateProvider> _dateProvider;
    NSMutableArray<AGURedeemedFeature*> *_features;
    NSMutableArray *_consumedOfferOccurrences;
    NSMutableSet<NSString*> *_consumedOffers;
}

@end

@implementation MockPersistenceLayer

- (instancetype)initWithDateProvider:(id<AGUDateProvider>)dateProvider
{
    self = [super init];
    if (self) {
        _dateProvider = dateProvider;
        _features = [NSMutableArray new];
        _consumedOfferOccurrences = [NSMutableArray new];
        _consumedOffers = [NSMutableSet new];
    }
    return self;
}

- (NSArray<AGURedeemedFeature*>*)availableFeatures
{
    return [_features copy];
}

- (void)deleteFeatures:(NSArray<AGUFeature*>*)featuresToDelete
{
    NSMutableArray<AGURedeemedFeature*> *redeemedFeaturesToDelete = [NSMutableArray new];
    for (AGUFeature *featureToDelete in featuresToDelete) {
        for (AGURedeemedFeature *redeemedFeature in _features) {
            if ([redeemedFeature.feature.name caseInsensitiveCompare:featureToDelete.name] == NSOrderedSame) {
                [redeemedFeaturesToDelete addObject:redeemedFeature];
            }
        }
    }

    [_features removeObjectsInArray:redeemedFeaturesToDelete];
}

- (void)wipe
{
    [_features removeAllObjects];
    [_consumedOfferOccurrences removeAllObjects];
    [_consumedOffers removeAllObjects];
}

- (void)markOfferAsConsumed:(AGUOffer*)offer
{
    [_consumedOffers addObject:[offer.token lowercaseString]];
}

- (void)markRepeatingOfferAsConsumed:(AGUOffer*)offer forDate:(NSDate*)date
{
    NSString *token = [offer.token lowercaseString];
    date = [[NSCalendar currentCalendar] startOfDayForDate:date];
    if (![self isRepeatingOfferTokenConsumed:token forDay:date]) {
        [_consumedOfferOccurrences addObject:[OfferOccurrence offerOccurrenceWithToken:token redeemDate:date]];
    }
}

- (void)saveFeature:(AGUFeature*)feature
{
    [_features addObject:[AGURedeemedFeature redeemedFeatureForFeature:feature redeemDate:[_dateProvider currentDate]]];
}

- (BOOL)isOfferTokenConsumed:(NSString*)offerToken
{
    return [_consumedOffers containsObject:[offerToken lowercaseString]];
}

- (BOOL)isRepeatingOfferTokenConsumed:(NSString*)offerToken forDay:(NSDate*)day
{
    return [_consumedOfferOccurrences containsObject:[OfferOccurrence offerOccurrenceWithToken:offerToken redeemDate:day]];
}

@end

@implementation OfferOccurrence

+ (instancetype)offerOccurrenceWithToken:(NSString*)token redeemDate:(NSDate*)redeemDate
{
    return [[OfferOccurrence alloc] initWithToken:token redeemDate:redeemDate];
}

- (instancetype)initWithToken:(NSString*)token redeemDate:(NSDate*)redeemDate
{
    self = [super init];
    if (self) {
        self.token = token;
        self.redeemDate = redeemDate;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return true;
    }
    
    if ([object isKindOfClass:[OfferOccurrence class]]) {
        OfferOccurrence *castedObject = (OfferOccurrence*)object;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        return [castedObject.token caseInsensitiveCompare:self.token] == NSOrderedSame && [calendar isDate:castedObject.redeemDate inSameDayAsDate:self.redeemDate];
    }
    return false;
}

@end
