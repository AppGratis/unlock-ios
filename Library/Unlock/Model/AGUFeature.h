//
//  AGUFeature.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGUItem.h"

FOUNDATION_EXPORT NSInteger const AGUFeatureUnlimitedLifetime;

/**
 Feature represents an unlockable feature: the UnlockManager will remember that the user unlocked it for its configured lifetime (which can be unlimited).
 */
@interface AGUFeature : AGUItem

/**
 Configured lifetime of the feature when it was consumed, in seconds.
 Will be AGUFeatureUnlimitedLifetime if unlimited.
 */
@property (nonatomic) NSInteger initialLifetime;

/**
 Time left until the user loses the feature, in seconds.
 You might wanna schedule a recheck of the feature availability some time after this.
 Will be nil if unlimited.
 */
@property (nonatomic, nullable) NSNumber *remainingLifetime;

/**
 Whether this feature should remain redeemed forever or if it expires
 */
@property (readonly) BOOL isTimeLimited;

@end
