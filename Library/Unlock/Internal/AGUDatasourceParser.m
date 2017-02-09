//
//  AGUDatasourceParser.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUDatasourceParser.h"

#import "AGURepeatCondition.h"
#import "AGUWeeklyRepeatCondition.h"

@implementation AGUDatasourceParser

static NSString *AGUDatasourceParserErrorDomain = @"com.appgratis.unlock.jsonparser";

static NSInteger AGUDatasourceParserTargetPayloadVersion = 1;

+ (NSArray<AGUOffer*>*)parseJSONString:(NSString*)json error:(NSError**)error
{
    NSError *jsonErr;
    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonErr];
    
    if (parsedJSON == nil) {
        if (jsonErr != nil) {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"An error occurred while parsing JSON.",
                                                    NSUnderlyingErrorKey: jsonErr}];
            }
            return nil;
        } else {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-2
                                         userInfo:@{NSLocalizedDescriptionKey: @"Unknown error while parsing JSON."}];
            }
            return nil;
        }
    }
    
    if (![parsedJSON isKindOfClass:[NSDictionary class]]) {
        if (error) {
            *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                       code:-3
                                     userInfo:@{NSLocalizedDescriptionKey: @"JSON parsed but is not of the expected type."}];
        }
        return nil;
    }
    
    NSInteger version = [[self numberForKey:@"version" dictionary:parsedJSON fallback:@0] integerValue];
    if (version > AGUDatasourceParserTargetPayloadVersion || version < 1) {
        if (error) {
            *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                         code:-5
                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid data version."}];
        }
        return nil;
    }
    
    NSArray *offers = [self objectForKey:@"offers" instanceOfClass:[NSArray class] dictionary:parsedJSON fallback:nil];
    
    if (offers == nil) {
        if (error) {
            *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                         code:-6
                                     userInfo:@{NSLocalizedDescriptionKey: @"No 'offers' array found."}];
        }
        return nil;
    }
    
    NSMutableArray<AGUOffer*> *parsedOffers = [NSMutableArray new];
    
    NSError *parsedOfferErr = nil;
    AGUOffer *parsedOffer = nil;
    
    for (id offer in offers) {
        if (![offer isKindOfClass:[NSDictionary class]]) {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-7
                                         userInfo:@{NSLocalizedDescriptionKey: @"Child of 'offers' array must all be objects."}];
            }
            return nil;
        }
        
        parsedOffer = [self parseOffer:(NSDictionary*)offer error:&parsedOfferErr];
        if (parsedOffer == nil) {
            if (error) {
                if (parsedOfferErr != nil) {
                    *error = parsedOfferErr;
                } else {
                    *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                                 code:-8
                                             userInfo:@{NSLocalizedDescriptionKey: @"Unknown error."}];
                }
            }
            
            return nil;
        }
        
        [parsedOffers addObject:parsedOffer];
    }
    
    return parsedOffers;
}

+ (nullable AGUOffer*)parseOffer:(nonnull NSDictionary*)offer error:(NSError**)error
{
    NSString *token = [self objectForKey:@"token" instanceOfClass:[NSString class] dictionary:offer fallback:nil];
    if ([token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                         code:-101
                                     userInfo:@{NSLocalizedDescriptionKey: @"Offers must have a token."}];
        }
        return nil;
    }
    
    NSError *err = nil;
    
    NSDictionary *jsonCondition = [self objectForKey:@"conditions" instanceOfClass:[NSDictionary class] dictionary:offer fallback:nil];
    if (jsonCondition == nil) {
        if (error) {
            *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                         code:-101
                                     userInfo:@{NSLocalizedDescriptionKey: @"Invalid offer condition."}];
        }
        return nil;
    }
    AGUBaseCondition *parsedCondition = [self parseCondition:jsonCondition error:&err];
    if (parsedCondition == nil) {
        if (error) {
            if (err != nil) {
                *error = err;
            } else {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-102
                                         userInfo:@{NSLocalizedDescriptionKey: @"Invalid offer condition."}];
            }
        }
        return nil;
    }
    
    NSMutableArray *parsedResources = [NSMutableArray new];
    NSArray *jsonResources = [self objectForKey:@"resources" instanceOfClass:[NSArray class] dictionary:offer fallback:nil];
    // No resources array is valid, don't fail
    for (id jsonResource in jsonResources) {
        if (![jsonResource isKindOfClass:[NSDictionary class]]) {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-103
                                         userInfo:@{NSLocalizedDescriptionKey: @"Invalid offer resources."}];
            }
            return nil;
        }
        
        AGUResource *parsedResource = [self parseResource:(NSDictionary*)jsonResource error:&err];
        
        if (parsedResource == nil) {
            if (error) {
                if (err != nil) {
                    *error = err;
                } else {
                    *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                                 code:-104
                                             userInfo:@{NSLocalizedDescriptionKey: @"Invalid offer resources."}];
                }
            }
            
            return nil;
        }

        [parsedResources addObject:parsedResource];
    }
    
    NSMutableArray *parsedFeatures = [NSMutableArray new];
    NSArray *jsonFeatures = [self objectForKey:@"features" instanceOfClass:[NSArray class] dictionary:offer fallback:nil];
    // No features array is valid, don't fail
    for (id jsonFeature in jsonFeatures) {
        if (![jsonFeature isKindOfClass:[NSDictionary class]]) {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-103
                                         userInfo:@{NSLocalizedDescriptionKey: @"Invalid offer features."}];
            }
            return nil;
        }
        
        AGUFeature *parsedFeature = [self parseFeature:(NSDictionary*)jsonFeature error:&err];
        
        if (parsedFeature == nil) {
            if (error) {
                if (err != nil) {
                    *error = err;
                } else {
                    *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                                 code:-104
                                             userInfo:@{NSLocalizedDescriptionKey: @"Invalid offer features."}];
                }
            }
            
            return nil;
        }
        
        [parsedFeatures addObject:parsedFeature];
    }
        
    AGUOffer *parsedOffer = [AGUOffer new];
    
    parsedOffer.token = token;
    parsedOffer.unlockMessage = [self objectForKey:@"unlock_message" instanceOfClass:[NSString class] dictionary:offer fallback:nil];
    parsedOffer.data = [self objectForKey:@"data" instanceOfClass:[NSDictionary class] dictionary:offer fallback:nil];
    parsedOffer.conditions = parsedCondition;
    parsedOffer.resources = parsedResources;
    parsedOffer.features = parsedFeatures;
    
    return parsedOffer;
}

+ (nullable AGUFeature*)parseFeature:(nonnull NSDictionary*)feature error:(NSError**)error
{
    NSString *name = [self objectForKey:@"name" instanceOfClass:[NSString class] dictionary:feature fallback:nil];
    if ([name length] == 0) {
        if (error) {
            *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                         code:-105
                                     userInfo:@{NSLocalizedDescriptionKey: @"Features must have a name."}];
        }
        return nil;
    }
    
    AGUFeature *parsedFeature = [AGUFeature new];
    parsedFeature.name = name;
    parsedFeature.initialLifetime = [[self numberForKey:@"ttl" dictionary:feature fallback:@(AGUFeatureUnlimitedLifetime)] integerValue];
    parsedFeature.remainingLifetime = @(parsedFeature.initialLifetime);
    return parsedFeature;
}

+ (nullable AGUResource*)parseResource:(nonnull NSDictionary*)resource error:(NSError**)error
{
    NSString *name = [self objectForKey:@"name" instanceOfClass:[NSString class] dictionary:resource fallback:nil];
    if ([name length] == 0) {
        if (error) {
            *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                         code:-106
                                     userInfo:@{NSLocalizedDescriptionKey: @"Resources must have a name."}];
        }
        return nil;
    }
    
    NSInteger quantity = [[self numberForKey:@"quantity" dictionary:resource fallback:@(-1)] integerValue];
    if (quantity < 1) {
        if (error) {
            *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                         code:-107
                                     userInfo:@{NSLocalizedDescriptionKey: @"Resources must have a quantity greater than zero."}];
        }
        return nil;
    }
    
    AGUResource *parsedResource = [AGUResource new];
    parsedResource.name = name;
    parsedResource.quantity = quantity;
    return parsedResource;
}

+ (nullable AGUBaseCondition*)parseCondition:(nonnull NSDictionary*)condition error:(NSError**)error
{
    AGUBaseCondition *parsedCondition = nil;
    
    NSDictionary *repeat = [self objectForKey:@"repeat" instanceOfClass:[NSDictionary class] dictionary:condition fallback:nil];
    if (repeat != nil) {
        NSString *frequency = [[self objectForKey:@"every" instanceOfClass:[NSString class] dictionary:repeat fallback:nil] uppercaseString];
        AGURepeatFrequency parsedFrequency;
        
        if ([frequency isEqualToString:@"DAY"]) {
            parsedFrequency = AGURepeatFrequencyDaily;
        } else if ([frequency isEqualToString:@"WEEK"]) {
            parsedFrequency = AGURepeatFrequencyWeekly;
        } else if ([frequency isEqualToString:@"MONTH"]) {
            parsedFrequency = AGURepeatFrequencyMonthly;
        } else {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-110
                                         userInfo:@{NSLocalizedDescriptionKey: @"'every' must be a valid repeat frequency (day, week, month)."}];
            }
            return nil;
        }
        
        if (parsedFrequency == AGURepeatFrequencyWeekly) {
            parsedCondition = [AGUWeeklyRepeatCondition new];
            
            NSString *weekday = [[self objectForKey:@"weekday" instanceOfClass:[NSString class] dictionary:repeat fallback:nil] uppercaseString];
            AGUWeekday parsedWeekday;
            
            if ([weekday isEqualToString:@"MONDAY"]) {
                parsedWeekday = AGUWeekdayMonday;
            } else if ([weekday isEqualToString:@"TUESDAY"]) {
                parsedWeekday = AGUWeekdayTuesday;
            } else if ([weekday isEqualToString:@"WEDNESDAY"]) {
                parsedWeekday = AGUWeekdayWednesday;
            } else if ([weekday isEqualToString:@"THURSDAY"]) {
                parsedWeekday = AGUWeekdayThursday;
            } else if ([weekday isEqualToString:@"FRIDAY"]) {
                parsedWeekday = AGUWeekdayFriday;
            } else if ([weekday isEqualToString:@"SATURDAY"]) {
                parsedWeekday = AGUWeekdaySaturday;
            } else if ([weekday isEqualToString:@"SUNDAY"]) {
                parsedWeekday = AGUWeekdaySunday;
            } else {
                if (error) {
                    *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                                 code:-110
                                             userInfo:@{NSLocalizedDescriptionKey: @"'weekday' must be a valid week day (monday, tuesday, etc...)."}];
                }
                return nil;
            }
            
            ((AGUWeeklyRepeatCondition*)parsedCondition).weekday = parsedWeekday;
        } else {
            parsedCondition = [AGURepeatCondition new];
        }
        
        ((AGURepeatCondition*)parsedCondition).frequency = parsedFrequency;
     
        NSNumber *startHour = [self numberForKey:@"start_hour" dictionary:repeat fallback:nil];
        NSNumber *endHour = [self numberForKey:@"end_hour" dictionary:repeat fallback:nil];
        
        if (startHour == nil || endHour == nil) {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-111
                                         userInfo:@{NSLocalizedDescriptionKey: @"'start_hour' and 'end_hour' are mandatory."}];
            }
            return nil;
        }
        
        NSInteger startHourInt = [startHour integerValue];
        if (startHourInt < 0 || startHourInt > 23) {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-112
                                         userInfo:@{NSLocalizedDescriptionKey: @"'start_hour' cannot be lower than 0 or greater than 23."}];
            }
            return nil;
        }
        
        NSInteger endHourInt = [endHour integerValue];
        if (endHourInt < 1 || endHourInt > 24) {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-113
                                         userInfo:@{NSLocalizedDescriptionKey: @"'end_hour' cannot be lower than 1 or greater than 24."}];
            }
            return nil;
        }
        
        ((AGURepeatCondition*)parsedCondition).startHour = startHourInt;
        ((AGURepeatCondition*)parsedCondition).endHour = endHourInt;
        
    } else {
        parsedCondition = [AGUBaseCondition new];
    }
    
    parsedCondition.newUsersOnly = [[self numberForKey:@"only_new_users" dictionary:condition fallback:@(NO)] boolValue];
    
    long long startDate = [[self numberForKey:@"start_date" dictionary:condition fallback:@(-1)] longLongValue];
    if (startDate < 0) {
        if (error) {
            *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                         code:-108
                                     userInfo:@{NSLocalizedDescriptionKey: @"'start_date' must be a valid timestamp."}];
        }
        return nil;
    }
    parsedCondition.startDate = [NSDate dateWithTimeIntervalSince1970:startDate];
    
    NSNumber *endDate = [self numberForKey:@"end_date" dictionary:condition fallback:nil];
    
    if (endDate != nil) {
        long long longEndDate = [endDate longLongValue];
        if (longEndDate < 0) {
            if (error) {
                *error = [NSError errorWithDomain:AGUDatasourceParserErrorDomain
                                             code:-109
                                         userInfo:@{NSLocalizedDescriptionKey: @"If supplied, 'end_date' must be a valid timestamp."}];
            }
            return nil;
        }
        parsedCondition.endDate = [NSDate dateWithTimeIntervalSince1970:longEndDate];
    } else {
        parsedCondition.endDate = nil;
    }
    
    if (error) {
        *error = nil;
    }
    
    return parsedCondition;
}

#pragma mark JSON Helper methods

+ (nullable id)objectForKey:(nonnull NSString*)key instanceOfClass:(Class)class dictionary:(nonnull NSDictionary*)dictionary fallback:(nullable id)fallback
{
    id value = [dictionary objectForKey:key];
    
    if (![value isKindOfClass:class]) {
        return fallback;
    }
    
    return value;
}

+ (nullable NSNumber*)numberForKey:(nonnull NSString*)key dictionary:(nonnull NSDictionary*)dictionary fallback:(nullable NSNumber*)fallback
{
    return [self objectForKey:key instanceOfClass:[NSNumber class] dictionary:dictionary fallback:fallback];
}

@end
