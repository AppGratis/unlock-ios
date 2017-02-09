//
//  AGURedeemedFeature.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGUFeature.h"

@interface AGURedeemedFeature : NSObject

+ (nonnull instancetype)redeemedFeatureForFeature:(nonnull AGUFeature*)feature redeemDate:(nonnull NSDate*)redeemDate;

- (nonnull instancetype)init NS_UNAVAILABLE;

- (nonnull instancetype)initWithFeature:(nonnull AGUFeature*)feature redeemDate:(nonnull NSDate*)redeemDate NS_DESIGNATED_INITIALIZER;

@property (nonnull) AGUFeature *feature;
@property (nonnull) NSDate *redeemDate;

@end
