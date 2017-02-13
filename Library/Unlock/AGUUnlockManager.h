//
//  AGUUnlockManager.h
//  AGUUnlock
//
//  Copyright © 2016 iMediapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AGUUnlock/AGUOfferSource.h>

#import <AGUUnlock/AGUFeature.h>
#import <AGUUnlock/AGUOffer.h>

NS_ASSUME_NONNULL_BEGIN


/**
 The AppGratis Unlock Manager.
 This is your main entry point to the unlock library.
 
 It manages:
  - Loading new rules from a file or from a json file in your bundle
  - Getting available features
  - Getting resources you should consume
  - Consuming resources
  - Wipe (clearing redeemed features)
 
 This class is not thread safe.
 */
@interface AGUUnlockManager : NSObject


/**
 Instanciate a new AGUUnlockManager instance for the given offers.

 @param offerSource Offer source implementation. See the documentation of AGUBuiltinOfferSource and AGUStringOfferSource to figure out which one fits your needs the best
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
 @return A new instance of AGUUnlockManager with the loaded offers if successful, nil otherwise.
 */
+ (instancetype _Nullable)managerForOfferSource:(id<AGUOfferSource> _Nonnull)offerSource error:(NSError**)error;


/**
 Returns the list of features the user should have access to.
 Only features you've previously marked as consumed will be available in this list.
 */
@property (readonly, nonnull) NSArray<AGUFeature*> *features;

/**
 Returns the list of offers that are redeemable.
 A redeemable offer is an offer that is present in the loaded offer source and has its conditions met when this method is called.
 */
@property (readonly, nonnull) NSArray<AGUOffer*> *pendingOffers;

/**
 Consume an offer. This will remove it from the pending offers if you query them again.
 Offer consumption is based on the unique offer tokens, and take into account the current date and time when consuming a recurring offer.
 
 This will also save the redeemed features so that they can be queried again using this manager.
 
 When consuming an offer, you should display the unlock message yourself, is one is provided with the offer:
 the unlock manager will make no attempt to do so itself.
 */
- (void)consumeOffer:(nonnull AGUOffer*)offer;

/**
 Wipe all data saved by the unlock manager. This includes redeemed offer tokens and features.
 */
- (void)wipeData;

@end

NS_ASSUME_NONNULL_END
