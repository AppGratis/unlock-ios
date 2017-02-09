//
//  AGUResource.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import "AGUItem.h"

/**
 Unlockable resource. This should be used for consumables, such as a virtual currency. 
 */
@interface AGUResource : AGUItem

/**
 Quantity of the resource to unlock
 */
@property (nonatomic, assign) NSUInteger quantity;

@end
