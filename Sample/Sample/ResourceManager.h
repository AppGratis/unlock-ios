//
//  ResourceManager.h
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 13/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kSampleResourceManagerUpdatedNotification;

/**
 Simple resource manager for sample purposes
 
 It's not threadsafe, but it's really only for sample purposes
 */
@interface ResourceManager : NSObject

- (NSInteger)quantityForResourceNamed:(NSString*)name;

- (void)addQuantity:(NSInteger)quantity forResource:(NSString*)resource;

@end
