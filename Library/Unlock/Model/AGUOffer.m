//
//  AGUOffer.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUOffer.h"

#import "AGURepeatCondition.h"

@implementation AGUOffer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.token = @"";
    }
    return self;
}

- (BOOL)isRepeating
{
    return [self.conditions isKindOfClass:[AGURepeatCondition class]];
}

@end
