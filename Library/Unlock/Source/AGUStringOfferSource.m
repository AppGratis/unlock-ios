//
//  AGUStringOfferSource.m
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUStringOfferSource.h"

@interface AGUStringOfferSource()
{
    NSString* _offersString;
}

@end

@implementation AGUStringOfferSource

+ (instancetype _Nonnull)sourceForString:(NSString* _Nonnull)offersString
{
    return [[AGUStringOfferSource alloc] initWithString:offersString];
}

- (instancetype _Nonnull)initWithString:(NSString* _Nonnull)offersString
{
    self = [super init];
    if (self) {
        _offersString = offersString;
    }
    return self;
}

- (NSString*)offersJSON
{
    return _offersString;
}

@end
