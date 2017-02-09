//
//  MockDateProvider.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "MockDateProvider.h"

@interface MockDateProvider ()
{
    NSDate *_currentDate;
    NSDate *_installDate;
}
@end

@implementation MockDateProvider

+ (instancetype)dateProviderWithCurrentDate:(NSDate*)currentDate
{
    return [MockDateProvider dateProviderWithCurrentDate:currentDate installDate:nil];
}

+ (instancetype)dateProviderWithCurrentDate:(NSDate*)currentDate installDate:(nullable NSDate*)installDate
{
    return [[MockDateProvider alloc] initWithCurrentDate:currentDate installDate:installDate];
}

- (instancetype)initWithCurrentDate:(NSDate*)currentDate installDate:(nullable NSDate*)installDate
{
    self = [super init];
    if (self) {
        _currentDate = currentDate;
        if (installDate != nil) {
            _installDate = installDate;
        } else {
            _installDate = currentDate;
        }
    }
    return self;
}

- (NSDate*)currentDate
{
    return _currentDate;
}

- (NSDate*)applicationInstallationDate
{
    return _installDate;
}

- (void)setMockedCurrentDate:(NSDate*)date
{
    _currentDate = date;
}

@end

