//
//  AGUOffer.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGUBaseCondition.h"
#import "AGUFeature.h"
#import "AGUResource.h"

/**
 
 */
@interface AGUOffer : NSObject

/**
 Unique offer token. You don't need to use this directly, the library will in order to register the offer consumptions.
 */
@property (nonatomic, nonnull) NSString *token;

/**
 Unlock message to display on offer consumption.
 */
@property (nonatomic, nullable) NSString *unlockMessage;

/**
 Offer eligibility condition.
 */
@property (nonatomic, nonnull) AGUBaseCondition *conditions;

/**
 Additional data, exactly as you set it when creating the offer. The nullable dictionary is a representation of the data JSON.
 */
@property (nonatomic, nullable) NSDictionary *data;

/**
 List of the features that should be unlocked when consuming this offer.
 */
@property (nonatomic, nonnull) NSArray<AGUFeature*> *features;

/**
 List of the resources that should be unlocked when consuming this offer.
 */
@property (nonatomic, nonnull) NSArray<AGUResource*> *resources;

/**
 Returns whether the offer is recurrent or not.
 */
- (BOOL)isRepeating;

@end
