//
//  AGUStringOfferSource.h
//  AGUUnlock
//
//  Created by Arnaud Barisain-Monrose on 15/10/2016.
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGUOfferSource.h"

@interface AGUStringOfferSource : NSObject <AGUOfferSource>

+ (instancetype _Nonnull)sourceForString:(NSString* _Nonnull)offersString;

- (instancetype _Nonnull)initWithString:(NSString* _Nonnull)offersString;

@end
