//
//  AGUSqliteTables.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUSqliteTables.h"

#import <sqlite3.h>

@implementation AGUSqliteFeatureTable

static NSString *AGUSqliteFeatureTableName = @"FEATURES";
static NSString *AGUSqliteFeatureTableColumn_DB_ID = @"_db_id";
static NSString *AGUSqliteFeatureTableColumn_Name = @"name";
static NSString *AGUSqliteFeatureTableColumn_TTL = @"ttl";
static NSString *AGUSqliteFeatureTableColumn_Redeem_Date = @"redeem_date";

+ (NSString*)createTableStatement
{
    return [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ("
            @"%@ integer primary key autoincrement, "
            @"%@ text not null, "
            @"%@ integer not null, "
            @"%@ integer not null, "
            @"unique(%@) on conflict replace);",
            AGUSqliteFeatureTableName,
            AGUSqliteFeatureTableColumn_DB_ID,
            AGUSqliteFeatureTableColumn_Name,
            AGUSqliteFeatureTableColumn_TTL,
            AGUSqliteFeatureTableColumn_Redeem_Date,
            AGUSqliteFeatureTableColumn_Name];
}

+ (NSString*)wipeStatement
{
    return [NSString stringWithFormat:@"DELETE FROM %@;", AGUSqliteFeatureTableName];
}

+ (nullable NSArray<AGURedeemedFeature*>*)redeemedFeaturesInDatabase:(sqlite3*)database error:(NSError**)error
{
    NSString *queryString = [NSString stringWithFormat:@"SELECT %@, %@, %@ FROM %@",
                             AGUSqliteFeatureTableColumn_Name,
                             AGUSqliteFeatureTableColumn_TTL,
                             AGUSqliteFeatureTableColumn_Redeem_Date,
                             AGUSqliteFeatureTableName];
    
    sqlite3_stmt *statement = NULL;
    if (sqlite3_prepare_v2(database, [queryString cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) != SQLITE_OK) {
        //TODO error
        return nil;
    }
    
    NSMutableArray *redeemedFeatures = [NSMutableArray new];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        AGUFeature *feature = [AGUFeature new];
        feature.name = [NSString stringWithUTF8String:(const char*) sqlite3_column_text(statement, 0)];
        feature.initialLifetime = (NSInteger)sqlite3_column_int64(statement, 1);
        NSDate *redeemDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 2)];
        [redeemedFeatures addObject:[AGURedeemedFeature redeemedFeatureForFeature:feature redeemDate:redeemDate]];
    }
    
    sqlite3_finalize(statement);
    
    return redeemedFeatures;
}

+ (BOOL)saveFeature:(AGUFeature*)feature database:(sqlite3*)database error:(NSError**)error
{
    sqlite3_stmt *statement = NULL;
    NSString *insertString = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@) VALUES (?, ?, ?)",
                              AGUSqliteFeatureTableName,
                              AGUSqliteFeatureTableColumn_Name,
                              AGUSqliteFeatureTableColumn_TTL,
                              AGUSqliteFeatureTableColumn_Redeem_Date];
    if (sqlite3_prepare_v2(database, [insertString cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) != SQLITE_OK) {
        //TODO error
        return false;
    }
    
    sqlite3_bind_text(statement, 1, [[feature.name lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding], -1, NULL);
    sqlite3_bind_int64(statement, 2, feature.initialLifetime);
    sqlite3_bind_double(statement, 3, [[NSDate date] timeIntervalSince1970]);
    
    NSError *stepErr = nil;
    if (sqlite3_step(statement) != SQLITE_DONE) {
        //TODO error, store it for later
    }
    
    sqlite3_finalize(statement);
    
    if (stepErr) {
        if (error) {
            *error = stepErr;
        }
        return false;
    }
    
    return true;
}

+ (BOOL)deleteFeatures:(NSArray<AGUFeature*>*)features database:(sqlite3*)database error:(NSError**)error
{
    if ([features count] == 0) {
        return YES;
    }
    
    NSMutableString *deleteString = [[NSMutableString alloc] initWithFormat:@"DELETE FROM %@ WHERE %@ IN (", AGUSqliteFeatureTableName, AGUSqliteFeatureTableColumn_Name];
    for (int i = 0; i < [features count]; i++) {
        if (i > 0) {
            [deleteString appendString:@","];
        }
        [deleteString appendString:@"?"];
    }
    [deleteString appendString:@");"];
    
    sqlite3_stmt *statement = NULL;
    if (sqlite3_prepare_v2(database, [deleteString cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) != SQLITE_OK) {
        //TODO error
        return false;
    }
    
    for (int i = 0; i < [features count]; i++) {
        sqlite3_bind_text(statement, i + 1, [features[i].name cStringUsingEncoding:NSUTF8StringEncoding], -1, NULL);
    }
    
    NSError *stepErr = nil;
    if (sqlite3_step(statement) != SQLITE_DONE) {
        //TODO error, store it for later
    }
    
    sqlite3_finalize(statement);
    
    if (stepErr) {
        if (error) {
            *error = stepErr;
        }
        return false;
    }
    
    return true;
}

@end

@implementation AGUSqliteOfferConsumptionTable

static NSString *AGUSqliteOfferConsumptionTableName = @"OFFER_CONSUMPTIONS";
static NSString *AGUSqliteOfferConsumptionTableColumn_DB_ID = @"_db_id";
static NSString *AGUSqliteOfferConsumptionTableColumn_Token = @"token";
static NSString *AGUSqliteOfferConsumptionTableColumn_Consumption_Date = @"consumption_date";

+ (NSString*)createTableStatement
{
    return [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ("
            @"%@ integer primary key autoincrement, "
            @"%@ text not null, "
            @"%@ integer not null, "
            @"unique(%@, %@) on conflict replace);",
            AGUSqliteOfferConsumptionTableName,
            AGUSqliteOfferConsumptionTableColumn_DB_ID,
            AGUSqliteOfferConsumptionTableColumn_Token,
            AGUSqliteOfferConsumptionTableColumn_Consumption_Date,
            AGUSqliteOfferConsumptionTableColumn_Token,
            AGUSqliteOfferConsumptionTableColumn_Consumption_Date];
}

+ (NSString*)wipeStatement
{
    return [NSString stringWithFormat:@"DELETE FROM %@;", AGUSqliteOfferConsumptionTableName];
}

+ (BOOL)insertOfferToken:(NSString*)token consumptionDate:(nullable NSDate*)consumptionDate database:(sqlite3*)database error:(NSError**)error
{
    sqlite3_stmt *statement = NULL;
    NSString *insertString = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (?, ?)", AGUSqliteOfferConsumptionTableName, AGUSqliteOfferConsumptionTableColumn_Token, AGUSqliteOfferConsumptionTableColumn_Consumption_Date];
    if (sqlite3_prepare_v2(database, [insertString cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) != SQLITE_OK) {
        //TODO error
        return false;
    }
    
    sqlite3_bind_text(statement, 1, [[token lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding], -1, NULL);
    sqlite3_bind_double(statement, 2, [consumptionDate timeIntervalSince1970]);
    
    NSError *stepErr = nil;
    if (sqlite3_step(statement) != SQLITE_DONE) {
        //TODO error, store it for later
    }
    
    sqlite3_finalize(statement);
    
    if (stepErr) {
        if (error) {
            *error = stepErr;
        }
        return false;
    }
    
    return true;
}

+ (BOOL)isOfferTokenConsumed:(NSString*)offerToken database:(sqlite3*)database error:(NSError**)error
{
    NSString *queryString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@ = ?1",
                             AGUSqliteOfferConsumptionTableName,
                             AGUSqliteOfferConsumptionTableColumn_Token];
    
    sqlite3_stmt *statement = NULL;
    if (sqlite3_prepare_v2(database, [queryString cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) != SQLITE_OK) {
        //TODO error
        return false;
    }
    
    sqlite3_bind_text(statement, 1, [[offerToken lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding], -1, NULL);
    
    int count = 0;
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        count = sqlite3_column_int(statement, 0);
    }
    
    sqlite3_finalize(statement);
    
    return count > 0;
}

+ (BOOL)isRepeatingOfferToken:(NSString*)offerToken consumedForDay:(NSDate*)day database:(sqlite3*)database error:(NSError**)error
{
    NSString *queryString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@ = ?1 AND %@ = ?2",
                             AGUSqliteOfferConsumptionTableName,
                             AGUSqliteOfferConsumptionTableColumn_Token,
                             AGUSqliteOfferConsumptionTableColumn_Consumption_Date];
    
    sqlite3_stmt *statement = NULL;
    if (sqlite3_prepare_v2(database, [queryString cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) != SQLITE_OK) {
        //TODO error
        return false;
    }
    
    sqlite3_bind_text(statement, 1, [[offerToken lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding], -1, NULL);
    sqlite3_bind_double(statement, 2, [day timeIntervalSince1970]);
    
    int count = 0;
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        count = sqlite3_column_int(statement, 0);
    }
    
    sqlite3_finalize(statement);
    
    return count > 0;
}

@end
