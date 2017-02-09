//
//  AGUDatasourceParser.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGUOffer.h"
#import "AGUFeature.h"
#import "AGUResource.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGUDatasourceParser : NSObject

+ (nullable NSArray<AGUOffer*>*)parseJSONString:(NSString*)json error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
