//
//  AGUDateProvider.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

@protocol AGUDateProvider <NSObject>

@property (readonly, nonnull) NSDate *currentDate;

@property (readonly, nonnull) NSDate *applicationInstallationDate;

@end
