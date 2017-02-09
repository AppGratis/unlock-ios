//
//  AGUWeeklyRepeatCondition.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGURepeatCondition.h"

typedef NS_ENUM(NSUInteger, AGUWeekday) {
    AGUWeekdaySunday = 1,
    AGUWeekdayMonday,
    AGUWeekdayTuesday,
    AGUWeekdayWednesday,
    AGUWeekdayThursday,
    AGUWeekdayFriday,
    AGUWeekdaySaturday,
};

@interface AGUWeeklyRepeatCondition : AGURepeatCondition

@property (nonatomic, assign) AGUWeekday weekday;

@end
