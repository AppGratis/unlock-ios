//
//  AGUSqliteTables.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGURedeemedFeature.h"

NS_ASSUME_NONNULL_BEGIN

// Forward declaration of sqlite3 to fix Swift integration of the framework
struct sqlite3;

@interface AGUSqliteFeatureTable : NSObject

+ (NSString*)createTableStatement;
+ (NSString*)wipeStatement;
+ (nullable NSArray<AGURedeemedFeature*>*)redeemedFeaturesInDatabase:(sqlite3*)database error:(NSError**)error;
+ (BOOL)saveFeature:(AGUFeature*)feature database:(sqlite3*)database error:(NSError**)error;
+ (BOOL)deleteFeatures:(NSArray<AGUFeature*>*)features database:(sqlite3*)database error:(NSError**)error;

@end

@interface AGUSqliteOfferConsumptionTable : NSObject

+ (NSString*)createTableStatement;
+ (NSString*)wipeStatement;
+ (BOOL)insertOfferToken:(NSString*)token consumptionDate:(nullable NSDate*)consumptionDate database:(sqlite3*)database error:(NSError**)error;
+ (BOOL)isOfferTokenConsumed:(NSString*)offerToken database:(sqlite3*)database error:(NSError**)error;
+ (BOOL)isRepeatingOfferToken:(NSString*)offerToken consumedForDay:(NSDate*)day database:(sqlite3*)database error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
