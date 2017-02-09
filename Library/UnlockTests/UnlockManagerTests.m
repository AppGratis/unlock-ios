//
//  UnlockTests.m
//  UnlockTests
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MockPayloads.h"
#import "MockDateProvider.h"
#import "MockPersistenceLayer.h"

#import "AGUUnlockManager.h"
#import "AGUStringOfferSource.h"
#import "AGUSqlitePersistenceLayer.h"
#import "AGURepeatCondition.h"

// Expose the AGUUnlockManager private methods for testing
@interface AGUUnlockManager ()

- (instancetype _Nullable)initWithOfferSource:(id<AGUOfferSource> _Nonnull)offerSource
                             persistenceLayer:(id<AGUPersistenceLayer> _Nonnull)persistenceLayer
                                 dateProvider:(id<AGUDateProvider> _Nonnull)dateProvider
                                        error:(NSError** _Nullable)outError;

- (void)addOffer:(AGUOffer*)offer;

- (NSArray<AGUOffer*>*)offers;

@end


/**
 Tests for AGUUnlockManager
 */
@interface UnlockManagerTests : XCTestCase
{
    MockDateProvider *_defaultDateProvider;
}

@end

@implementation UnlockManagerTests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = false;
    _defaultDateProvider = [MockDateProvider dateProviderWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:1473233828]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOfferParsing {
    MockPersistenceLayer *pl = [[MockPersistenceLayer alloc] initWithDateProvider:_defaultDateProvider];
    
    NSArray<NSString*> *validPayloads = @[MOCK_PAYLOAD_EMPTY, MOCK_PAYLOAD_BASIC, MOCK_PAYLOAD_FULL];
    
    for (NSString *validPayload in validPayloads) {
        NSError *err = nil;
        AGUUnlockManager *manager = [[AGUUnlockManager alloc] initWithOfferSource:[AGUStringOfferSource sourceForString:validPayload]
                                                                 persistenceLayer:pl
                                                                     dateProvider:_defaultDateProvider
                                                                            error:&err];
        XCTAssertNil(err, @"Unexpected error for valid payload: %@", [err localizedDescription]);
        XCTAssertNotNil(manager, @"Expected a non nil manager for a valid payload.");
    }
    
    NSArray<NSDictionary*> *invalidPayloads = @[@{@"payload":MOCK_PAYLOAD_INVALID_TOKEN, @"description": @"No offer tokens"},
                                                @{@"payload":MOCK_PAYLOAD_INVALID_CONDITIONS, @"description": @"No offer conditions"}];
    
    for (NSDictionary *invalidPayload in invalidPayloads) {
        NSError *err = nil;
        AGUUnlockManager *manager = [[AGUUnlockManager alloc] initWithOfferSource:[AGUStringOfferSource sourceForString:invalidPayload[@"payload"]]
                                                                 persistenceLayer:pl
                                                                     dateProvider:_defaultDateProvider
                                                                            error:&err];
        XCTAssertNotNil(err, @"Invalid payload (%@) should have returned an error.", invalidPayload[@"description"]);
        XCTAssertNil(manager, @"Manager not nil for invalid payload (%@).", invalidPayload[@"description"]);
    }
}

- (void)testOfferValidity {
    AGUUnlockManager *manager = [[AGUUnlockManager alloc] initWithOfferSource:[AGUStringOfferSource sourceForString:MOCK_PAYLOAD_FULL]
                                                             persistenceLayer:[[MockPersistenceLayer alloc] initWithDateProvider:_defaultDateProvider]
                                                                 dateProvider:_defaultDateProvider
                                                                        error:nil];
    
    XCTAssertNotNil(manager);
    
    XCTAssertEqual(1, [manager pendingOffers].count);
    XCTAssertEqual(3, [manager offers].count);
}

- (void)testOfferConsumption {
    [self baseTestOfferConsumptionWithPersistenceLayer:[[MockPersistenceLayer alloc] initWithDateProvider:_defaultDateProvider]];
    AGUSqlitePersistenceLayer *sqliteLayer = [[AGUSqlitePersistenceLayer alloc] init];
    XCTAssertNotNil(sqliteLayer, "Failed to initialize the SQLite persistence layer");
    [self baseTestOfferConsumptionWithPersistenceLayer:sqliteLayer];
}

- (void)testOfferOccurrenceConsumption {
    [self baseTestOfferOccurrenceConsumptionWithPersistenceLayer:[[MockPersistenceLayer alloc] initWithDateProvider:_defaultDateProvider]]; // We don't care about the mocked date
    AGUSqlitePersistenceLayer *sqliteLayer = [[AGUSqlitePersistenceLayer alloc] init];
    XCTAssertNotNil(sqliteLayer, "Failed to initialize the SQLite persistence layer");
    [self baseTestOfferOccurrenceConsumptionWithPersistenceLayer:sqliteLayer];
}

#pragma mark Helper methods

- (void)baseTestOfferConsumptionWithPersistenceLayer:(id<AGUPersistenceLayer>)persistenceLayer {
    NSString *assertAdditionalDescription = [NSString stringWithFormat:@"Persistence Layer: %@", NSStringFromClass([persistenceLayer class])];
    
    AGUUnlockManager *manager = [[AGUUnlockManager alloc] initWithOfferSource:[AGUStringOfferSource sourceForString:MOCK_PAYLOAD_FULL]
                                                             persistenceLayer:persistenceLayer
                                                                 dateProvider:[MockDateProvider dateProviderWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:1473233828]]
                                                                        error:nil];
    
    XCTAssertNotNil(manager, @"%@", assertAdditionalDescription);
    
    [manager wipeData];
    
    XCTAssertEqual(0, [manager features].count, @"%@", assertAdditionalDescription);
    
    AGUOffer* offer = [manager pendingOffers][0];
    XCTAssertNotNil(offer, @"%@", assertAdditionalDescription);
    
    [manager consumeOffer:offer];
    XCTAssertEqual(1, [manager features].count, @"%@", assertAdditionalDescription);
    XCTAssertEqual(0, [manager pendingOffers].count, @"%@", assertAdditionalDescription);
}

- (void)baseTestOfferOccurrenceConsumptionWithPersistenceLayer:(id<AGUPersistenceLayer>)persistenceLayer {
    NSString *assertAdditionalDescription = [NSString stringWithFormat:@"Persistence Layer: %@", NSStringFromClass([persistenceLayer class])];
    
    MockDateProvider *dp = [MockDateProvider dateProviderWithCurrentDate:[NSDate dateWithTimeIntervalSince1970:1454493600]]; // 2016-02-03 10:00:00 GMT
    
    AGUUnlockManager *manager = [[AGUUnlockManager alloc] initWithOfferSource:[AGUStringOfferSource sourceForString:@"{\"version\":1, \"offers\":[]}"]
                                                             persistenceLayer:persistenceLayer
                                                                 dateProvider:dp
                                                                        error:nil];
    
    XCTAssertNotNil(manager, @"%@", assertAdditionalDescription);
    
    [manager wipeData];
    XCTAssertEqual(0, [manager offers].count, @"%@", assertAdditionalDescription);
    
    AGUOffer* offer = [[AGUOffer alloc] init];
    offer.token = @"test";
    
    AGURepeatCondition *testCondition = [[AGURepeatCondition alloc] init];
    testCondition.startDate = [dp currentDate];
    testCondition.endDate = nil;
    testCondition.startHour = 0;
    testCondition.endHour = 24;
    testCondition.frequency = AGURepeatFrequencyDaily;
    testCondition.newUsersOnly = false;
    offer.conditions = testCondition;
    [manager addOffer:offer];
    
    XCTAssertEqual(1, [manager pendingOffers].count, @"%@", assertAdditionalDescription);
    [manager consumeOffer:offer];
    
    XCTAssertEqual(0, [manager pendingOffers].count, @"%@", assertAdditionalDescription);
    
    [dp setMockedCurrentDate:[NSDate dateWithTimeIntervalSince1970:1454580000]]; // 2016-02-04 10:00:00 GMT
    XCTAssertEqual(1, [manager pendingOffers].count, @"%@", assertAdditionalDescription);
    
    [manager consumeOffer:offer];
    XCTAssertEqual(0, [manager pendingOffers].count, @"%@", assertAdditionalDescription);
    
    [manager wipeData];
}

@end
