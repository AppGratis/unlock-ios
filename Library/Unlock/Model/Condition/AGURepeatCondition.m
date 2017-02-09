//
//  AGURepeatCondition.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGURepeatCondition.h"

@implementation AGURepeatCondition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startHour = 0;
        self.endHour = 0;
        self.frequency = AGURepeatFrequencyDaily;
    }
    return self;
}

- (BOOL)isSatisfied:(nonnull id<AGUDateProvider>)dateProvider
{
    if (![super isSatisfied:dateProvider]) {
        return false;
    }
    
    NSDate *currentDate = [dateProvider currentDate];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSInteger hourOfDay = [currentCalendar component:NSCalendarUnitHour fromDate:currentDate];
    
    if (hourOfDay < self.startHour || hourOfDay > self.endHour) {
        return false;
    }
    
    //Daily frequency is always satisfied
    //Weekly will be handled by AGUWeeklyRepeatCondition
    if (self.frequency == AGURepeatFrequencyMonthly) {
        // The monthly frequency checks that the day of the month of the start date is the same as today's
        // For example, a start date of 2016/12/03 with a monthly req, will be valid on 2016/
        // If the last day of month is inferior to the start date's day of month, don't fail the condition
        
        NSInteger startDay = [currentCalendar component:NSCalendarUnitDay fromDate:self.startDate];
        NSInteger currentDay = [currentCalendar component:NSCalendarUnitDay fromDate:currentDate];
        NSInteger numberOfDaysInCurrentMonth = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate].length;
        
        if (startDay < numberOfDaysInCurrentMonth && startDay != currentDay) {
            return false;
        }
    }
    
    return true;
}

@end
