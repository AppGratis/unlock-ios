//
//  MockPersistenceLayer.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AGUUnlock/AGUPersistenceLayer.h>
#import "AGUDateProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface MockPersistenceLayer : NSObject <AGUPersistenceLayer>

- (instancetype)initWithDateProvider:(id<AGUDateProvider>)dateProvider;

@end

@interface OfferOccurrence : NSObject

+ (instancetype)offerOccurrenceWithToken:(NSString*)token redeemDate:(NSDate*)redeemDate;

@property (nonnull) NSString *token;
@property (nonnull) NSDate *redeemDate;

@end

NS_ASSUME_NONNULL_END
