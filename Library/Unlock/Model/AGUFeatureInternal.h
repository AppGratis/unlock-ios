//
//  AGUFeatureInternal.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

@interface AGUFeature()

/**
 Whether this feature is expired or not. Note that this isn't dynamically updated, and represents the state of the offer when it was queried from the Unlock Manager
 */
@property (readonly) BOOL isExpired;

- (void)updateRemainingLifetimeForDate:(nonnull NSDate*)currentDate redeemDate:(nonnull NSDate*)redeemDate;

@end
