//
//  AGUBaseCondition.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUBaseCondition.h"

@implementation AGUBaseCondition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startDate = [NSDate date];
        self.newUsersOnly = false;
    }
    return self;
}

- (BOOL)isSatisfied:(nonnull id<AGUDateProvider>)dateProvider
{
    NSDate *currentDate = [dateProvider currentDate];
    
    if ([currentDate compare:self.startDate] == NSOrderedAscending) {
        // Offer hasn't started yet
        return false;
    }
    
    if (self.endDate != nil && [currentDate compare:self.endDate] == NSOrderedDescending) {
        // Offer is over
        return false;
    }
    
    NSDate *appInstallDate = [dateProvider applicationInstallationDate];
    if (self.newUsersOnly && appInstallDate != nil && [appInstallDate compare:self.startDate] == NSOrderedAscending) {
        // Start date is known and the user installed after the offer stard date, and the offer is only for new users
        return false;
    }
    
    return true;
}

@end
