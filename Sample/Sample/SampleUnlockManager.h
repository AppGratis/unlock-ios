//
//  SampleUnlockManager.h
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 13/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AGUUnlock;

FOUNDATION_EXPORT NSString * _Nonnull const kSampleUnlockManagerUpdatedNotification;

/**
 Sample unlock manager, which talks to the unlock library and shows unlock messages
 */
@interface SampleUnlockManager : NSObject

// Only for sample purposes ;)
+ (nonnull instancetype)sharedInstance;

@property (readonly, nonnull) NSArray<AGUFeature*> *features;

@property (readonly, nonnull) NSArray<AGUOffer*> *pendingOffers;

- (void)consumeOffer:(nonnull AGUOffer*)offer;

@end
