//
//  AGUSystemDateProvider.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUSystemDateProvider.h"

@implementation AGUSystemDateProvider

- (NSDate*)currentDate
{
    return [NSDate date];
}

- (NSDate*)applicationInstallationDate
{
    NSDate *installDate = nil;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *documentsFolder = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    if (documentsFolder != nil) {
        installDate = [fm attributesOfItemAtPath:documentsFolder.path error:nil][NSFileCreationDate];
    }
    
    return installDate != nil ? installDate : [NSDate date];
}

@end
