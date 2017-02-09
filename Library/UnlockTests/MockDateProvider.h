//
//  MockDateProvider.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGUDateProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface MockDateProvider : NSObject <AGUDateProvider>

+ (instancetype)dateProviderWithCurrentDate:(NSDate*)currentDate;
+ (instancetype)dateProviderWithCurrentDate:(NSDate*)currentDate installDate:(nullable NSDate*)installDate;

- (void)setMockedCurrentDate:(NSDate*)date;

@end

NS_ASSUME_NONNULL_END
