#import <XCTest/XCTest.h>

#import "AGUBuiltinOfferSource.h"

const NSString* kOfferSourceErrorDomain = @"com.appgratis.unlock.offersource.builtin.error";

@interface BuiltinOfferSourceTests : XCTestCase

@end

@implementation BuiltinOfferSourceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNilFilename {
    NSError *err;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    id source = [[AGUBuiltinOfferSource alloc] initWithFilename:nil error:&err];
#pragma clang diagnostic pop
    XCTAssertNil(source);
    [self performCommonTestsForError:err code:-10];
}

- (void)testNonexistentFile {
    NSError *err;
    id source = [[AGUBuiltinOfferSource alloc] initWithFilename:@"offerz" error:&err];
    XCTAssertNil(source);
    [self performCommonTestsForError:err code:-20];
}

- (void)testValidFile {
    NSError *err;
    AGUBuiltinOfferSource *source = [[AGUBuiltinOfferSource alloc] initWithFilename:@"offers" inBundle:[NSBundle bundleForClass:[self class]] error:&err];
    XCTAssertNotNil(source);
    XCTAssertNotNil([source offersJSON]);
    XCTAssertNil(err);
}

- (void)performCommonTestsForError:(NSError*)err code:(NSInteger)code
{
    XCTAssertNotNil(err);
    XCTAssertEqualObjects(kOfferSourceErrorDomain, err.domain);
    XCTAssertNotNil(err.localizedDescription);
}

@end
