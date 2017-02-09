//
//  AGUFeature.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUFeature.h"
#import "AGUFeatureInternal.h"

NSInteger const AGUFeatureUnlimitedLifetime = -1;

@implementation AGUFeature

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.initialLifetime = AGUFeatureUnlimitedLifetime;
    }
    return self;
}

 -(BOOL)isTimeLimited
{
    return self.initialLifetime == AGUFeatureUnlimitedLifetime;
}

- (BOOL)isExpired
{
    return [self isTimeLimited] && self.remainingLifetime != nil && [self.remainingLifetime integerValue] <= 0;
}

- (void)updateRemainingLifetimeForDate:(nonnull NSDate*)currentDate redeemDate:(nonnull NSDate*)redeemDate
{
    if (![self isTimeLimited]) {
        self.remainingLifetime = nil;
        return;
    }
    
    NSTimeInterval elapsedTimeSinceRedeem = [currentDate timeIntervalSinceDate:redeemDate];
    self.remainingLifetime = @(self.initialLifetime - (long long)elapsedTimeSinceRedeem);
}

@end
