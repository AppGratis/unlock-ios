//
//  AGUSqlitePersistenceLayer.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUSqlitePersistenceLayer.h"

#import <sqlite3.h>

#import "AGUSqliteTables.h"

@interface AGUSqlitePersistenceLayer ()
{
    sqlite3 *_database;
}
@end

@implementation AGUSqlitePersistenceLayer

static NSString *AGUSqlitePersistenceLayerDBName = @"appgratis_unlocks.db";
static NSString *AGUSqlitePersistenceLayerDBNVersionDefaultsKey = @"com.appgratis.unlock.db_version";
static const NSInteger AGUSqlitePersistenceLayerDBVersion = 1;

- (nullable instancetype)init
{
    self = [super init];
    if (self) {
        if (![self setupDatabase]) {
            return nil;
        }
    }
    return self;
}

- (BOOL)setupDatabase
{
    _database = NULL;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *documentsFolder = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    if (documentsFolder == nil) {
        //TODO Handle errors
        return false;
    }
    
    NSString *dbPath = [[documentsFolder absoluteString] stringByAppendingPathComponent:@"appgratis_unlocks.db"];
    if (dbPath == nil) {
        //TODO errors
        return false;
    }
    
    // This will be useful later if we need to change the DB version
    [[NSUserDefaults standardUserDefaults] setObject:@(AGUSqlitePersistenceLayerDBVersion) forKey:AGUSqlitePersistenceLayerDBNVersionDefaultsKey];
    
    if (sqlite3_open([dbPath cStringUsingEncoding:NSUTF8StringEncoding], &_database) != SQLITE_OK) {
        _database = NULL;
        return false;
    }
    
    if (sqlite3_exec(_database, [[AGUSqliteFeatureTable createTableStatement] cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL) != SQLITE_OK) {
        //TODO errors
        return false;
    }
    
    if (sqlite3_exec(_database, [[AGUSqliteOfferConsumptionTable createTableStatement] cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL) != SQLITE_OK) {
        //TODO errors
        return false;
    }
    
    return true;
}

#pragma mark AGUPersistenceLayer methods

- (NSArray<AGURedeemedFeature*>*)availableFeatures
{
    //TODO error
    NSArray<AGURedeemedFeature*>* features = [AGUSqliteFeatureTable redeemedFeaturesInDatabase:_database error:nil];
    if (features == nil) {
        return @[];
    }
    return features;
}

- (void)deleteFeatures:(NSArray<AGUFeature*>*)features
{
    //TODO: Error
    [AGUSqliteFeatureTable deleteFeatures:features database:_database error:nil];
}

- (void)wipe
{
    NSString *wipeStatement = [NSString stringWithFormat:@"%@%@", [AGUSqliteFeatureTable wipeStatement], [AGUSqliteOfferConsumptionTable wipeStatement]];
    if (sqlite3_exec(_database, [wipeStatement cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL) != SQLITE_OK) {
        //TODO errors
        return;
    }
}

- (void)markOfferAsConsumed:(AGUOffer*)offer
{
    //TODO: Error
    [AGUSqliteOfferConsumptionTable insertOfferToken:offer.token consumptionDate:nil database:_database error:nil];
}

- (void)markRepeatingOfferAsConsumed:(AGUOffer*)offer forDate:(NSDate*)date
{
    //TODO: Error
    date = [[NSCalendar currentCalendar] startOfDayForDate:date];
    [AGUSqliteOfferConsumptionTable insertOfferToken:offer.token consumptionDate:date database:_database error:nil];
}

- (void)saveFeature:(AGUFeature*)feature
{
    [AGUSqliteFeatureTable saveFeature:feature database:_database error:nil];
}

- (BOOL)isOfferTokenConsumed:(NSString*)offerToken
{
    //TODO error
    return [AGUSqliteOfferConsumptionTable isOfferTokenConsumed:offerToken database:_database error:nil];;
}

- (BOOL)isRepeatingOfferTokenConsumed:(NSString*)offerToken forDay:(NSDate*)day
{
    day = [[NSCalendar currentCalendar] startOfDayForDate:day];
    //TODO error
    return [AGUSqliteOfferConsumptionTable isRepeatingOfferToken:offerToken consumedForDay:day database:_database error:nil];
}

@end
