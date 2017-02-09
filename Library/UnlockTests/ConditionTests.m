//
//  ConditionTests.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AGUBaseCondition.h"
#import "AGURepeatCondition.h"
#import "AGUWeeklyRepeatCondition.h"

#import "MockDateProvider.h"

static NSDateFormatter *conditionDateFormatter;

@interface ConditionTests : XCTestCase
{
    
}

@end

@implementation ConditionTests

+ (void)setUp
{
    conditionDateFormatter = [NSDateFormatter new];
    conditionDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    conditionDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStartCondition
{
    AGUBaseCondition *mockCondition = [AGUBaseCondition new];
    mockCondition.startDate = [conditionDateFormatter dateFromString:@"2016-02-01 18:00:00"];
    mockCondition.endDate = nil;
    mockCondition.newUsersOnly = false;
    
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-02-01 18:00:00"]]);
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-02-01 18:00:01"]]);
    
    XCTAssertFalse([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-02-01 17:59:59"]]);
}

- (void)testEndCondition
{
    AGUBaseCondition *mockCondition = [AGUBaseCondition new];
    mockCondition.startDate = [conditionDateFormatter dateFromString:@"2016-02-01 18:00:00"];
    mockCondition.endDate = nil;
    mockCondition.newUsersOnly = false;
    
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-02-01 18:00:00"]]);
    
    mockCondition.endDate = [conditionDateFormatter dateFromString:@"2016-02-02 15:00:00"];
    XCTAssertTrue([mockCondition isSatisfied:[MockDateProvider dateProviderWithCurrentDate:mockCondition.endDate]]);
    XCTAssertFalse([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-02-02 15:00:01"]]);
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-02-01 18:00:00"]]);
}

- (void)testNewUsersCondition
{
    MockDateProvider *dateProvider = [MockDateProvider dateProviderWithCurrentDate:[conditionDateFormatter dateFromString:@"2016-02-02 18:00:00"]
                                                                       installDate:[conditionDateFormatter dateFromString:@"2010-01-01 18:00:00"]];
    
    MockDateProvider *dateProviderNewUser = [MockDateProvider dateProviderWithCurrentDate:[conditionDateFormatter dateFromString:@"2016-02-02 18:00:00"]
                                                                              installDate:[conditionDateFormatter dateFromString:@"2016-02-02 18:00:00"]];
    
    AGUBaseCondition *mockCondition = [AGUBaseCondition new];
    mockCondition.startDate = [conditionDateFormatter dateFromString:@"2016-02-02 18:00:00"];
    mockCondition.endDate = nil;
    mockCondition.newUsersOnly = false;
    
    XCTAssertTrue([mockCondition isSatisfied:dateProvider]);
    XCTAssertTrue([mockCondition isSatisfied:dateProviderNewUser]);
    
    mockCondition.newUsersOnly = true;
    
    XCTAssertFalse([mockCondition isSatisfied:dateProvider]);
    XCTAssertTrue([mockCondition isSatisfied:dateProviderNewUser]);
}

- (void)testDailyRepeatCondition
{
    AGURepeatCondition *mockCondition = [AGURepeatCondition new];
    mockCondition.startDate = [conditionDateFormatter dateFromString:@"2010-02-02 18:00:00"];
    mockCondition.endDate = nil;
    mockCondition.newUsersOnly = false;
    mockCondition.frequency = AGURepeatFrequencyDaily;
    mockCondition.startHour = 18;
    mockCondition.endHour = 20;
    
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2010-02-02 19:00:00"]]);
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-03-04 18:00:00"]]);
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-05-08 20:00:00"]]);
    
    XCTAssertFalse([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-05-08 17:59:59"]]);
    XCTAssertFalse([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-05-08 21:00:00"]]);
}

- (void)testWeeklyRepeatCondition
{
    AGUWeeklyRepeatCondition *mockCondition = [AGUWeeklyRepeatCondition new];
    mockCondition.startDate = [conditionDateFormatter dateFromString:@"2010-02-02 18:00:00"];
    mockCondition.endDate = nil;
    mockCondition.newUsersOnly = false;
    mockCondition.frequency = AGURepeatFrequencyWeekly;
    mockCondition.weekday = AGUWeekdayFriday;
    mockCondition.startHour = 18;
    mockCondition.endHour = 20;
    
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-09-09 18:00:00"]]);
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-09-16 18:00:00"]]);
    
    XCTAssertFalse([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-09-15 18:00:00"]]);
    XCTAssertFalse([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-09-17 18:00:00"]]);
    
    mockCondition.weekday = AGUWeekdayThursday;
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-09-15 18:00:00"]]);
    
    mockCondition.weekday = AGUWeekdaySaturday;
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-09-17 18:00:00"]]);
}

- (void)testMonthlyRepeatCondition
{
    AGURepeatCondition *mockCondition = [AGURepeatCondition new];
    mockCondition.startDate = [conditionDateFormatter dateFromString:@"2010-02-02 18:00:00"];
    mockCondition.endDate = nil;
    mockCondition.newUsersOnly = false;
    mockCondition.frequency = AGURepeatFrequencyMonthly;
    mockCondition.startHour = 18;
    mockCondition.endHour = 20;
    
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2010-02-02 18:00:00"]]);
    
    XCTAssertFalse([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-03-04 18:00:00"]]);
    XCTAssertFalse([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-05-08 20:00:00"]]);
    
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-03-02 18:00:00"]]);
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-05-02 20:00:00"]]);
    
    mockCondition.startDate = [conditionDateFormatter dateFromString:@"2016-08-31 18:00:00"];
    
    XCTAssertTrue([mockCondition isSatisfied:[MockDateProvider dateProviderWithCurrentDate:mockCondition.startDate]]);
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2016-09-30 18:00:00"]]);
    XCTAssertTrue([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2017-02-28 18:00:00"]]);
    
    XCTAssertFalse([mockCondition isSatisfied:[self mockDateProviderForDateString:@"2015-09-30 18:00:00"]]);
}

- (MockDateProvider*)mockDateProviderForDateString:(NSString*)dateString
{
    return [MockDateProvider dateProviderWithCurrentDate:[conditionDateFormatter dateFromString:dateString]];
}

@end
