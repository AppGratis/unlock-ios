//
//  ResourceManager.m
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 13/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import "ResourceManager.h"

NSString *const kSampleResourceManagerUpdatedNotification = @"com.appgratis.unlock.Sample.ResourceManager.updated";

@implementation ResourceManager

- (NSInteger)quantityForResourceNamed:(NSString*)name
{
    return [[self numberForResourceName:name] integerValue];
}

- (void)addQuantity:(NSInteger)quantity forResource:(NSString*)resource
{
    // Yes, this may overflow
    [self saveQuantity:([self quantityForResourceNamed:resource]+1) forResourceNamed:resource];
}

- (void)saveQuantity:(NSInteger)quantity forResourceNamed:(NSString*)name
{
    [self saveNumber:@(quantity) forResourceName:name];
}

- (void)saveNumber:(NSNumber*)number forResourceName:(NSString*)name
{
    number = number ? number : @(0);
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:[self keyForResourceName:name]];
}

- (NSNumber*)numberForResourceName:(NSString*)name
{
    NSNumber *retVal = [[NSUserDefaults standardUserDefaults] objectForKey:[self keyForResourceName:name]];
    return retVal ? retVal : @(0);
}

- (NSString*)keyForResourceName:(NSString*)name
{
    return [@"resource_" stringByAppendingString:name];
}

@end
