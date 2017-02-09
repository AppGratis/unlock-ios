//
//  AGURedeemedFeature.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGURedeemedFeature.h"

@implementation AGURedeemedFeature

+ (instancetype)redeemedFeatureForFeature:(AGUFeature*)feature redeemDate:(NSDate*)redeemDate
{
    return [[AGURedeemedFeature alloc] initWithFeature:feature redeemDate:redeemDate];
}

- (instancetype)initWithFeature:(AGUFeature*)feature redeemDate:(NSDate*)redeemDate
{
    self = [super init];
    if (self) {
        self.feature = feature;
        self.redeemDate = redeemDate;
    }
    return self;
}

@end
