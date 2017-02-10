//
//  AGUSqlitePersistenceLayer.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGUPersistenceLayer.h"

@interface AGUSqlitePersistenceLayer : NSObject <AGUPersistenceLayer>

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end
