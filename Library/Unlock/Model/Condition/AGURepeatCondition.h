//
//  AGURepeatCondition.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUBaseCondition.h"

typedef NS_ENUM(NSUInteger, AGURepeatFrequency) {
    AGURepeatFrequencyDaily,
    AGURepeatFrequencyWeekly,
    AGURepeatFrequencyMonthly,
};

@interface AGURepeatCondition : AGUBaseCondition

@property (nonatomic, assign) NSUInteger startHour;

@property (nonatomic, assign) NSUInteger endHour;

@property (nonatomic, assign) AGURepeatFrequency frequency;

@end
