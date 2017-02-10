//
//  AGUBuiltinOfferSource.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGUOfferSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGUBuiltinOfferSource : NSObject <AGUOfferSource>

- (nullable instancetype)initWithFilename:(NSString*)filename error:(NSError**)error;

- (nullable instancetype)initWithFilename:(NSString*)filename inBundle:(NSBundle*)bundle error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
