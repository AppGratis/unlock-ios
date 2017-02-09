//
//  AGUWeeklyRepeatCondition.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUWeeklyRepeatCondition.h"

@implementation AGUWeeklyRepeatCondition

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.weekday = AGUWeekdayMonday;
    }
    return self;
}

- (BOOL)isSatisfied:(nonnull id<AGUDateProvider>)dateProvider
{
    if (![super isSatisfied:dateProvider]) {
        return false;
    }
    
    NSDate *currentDate = [dateProvider currentDate];
    NSCalendar *currentCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]; // Weekly recurrence only works on gregorian calendars
    return [currentCalendar component:NSCalendarUnitWeekday fromDate:currentDate] == self.weekday;
}

@end
