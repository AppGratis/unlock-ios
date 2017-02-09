//
//  AGUBaseCondition.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGUDateProvider.h"

@interface AGUBaseCondition : NSObject

@property (nonatomic, nonnull) NSDate *startDate;

@property (nonatomic, nullable) NSDate *endDate;

@property (nonatomic, assign) BOOL newUsersOnly;

- (BOOL)isSatisfied:(nonnull id<AGUDateProvider>)dateProvider;

@end
