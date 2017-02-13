//
//  SampleUnlockManager.m
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 13/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import "SampleUnlockManager.h"

#import "ResourceManager.h"

NSString *const kSampleUnlockManagerUpdatedNotification = @"com.appgratis.unlock.Sample.SampleUnlockManager.updated";

@import AGUUnlock;

@interface SampleUnlockManager()
{
    AGUUnlockManager *_unlockManager;
    ResourceManager *_resourceManager;
}
@end

@implementation SampleUnlockManager

+ (instancetype)sharedInstance
{
    static SampleUnlockManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SampleUnlockManager new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _resourceManager = [ResourceManager new];
        
        NSError *err;
        id<AGUOfferSource> offerSource = [[AGUBuiltinOfferSource alloc] initWithFilename:@"offers" error:&err];
        
        if (offerSource == nil) {
            NSLog(@"An error occurred while initializing AGUUnlock's offer source. Offers and redeemed features will not be available.");
            if (err != nil) {
                NSLog(@"Error: %@", err.localizedDescription);
            }
        } else {
            err = NULL;
            
            _unlockManager = [AGUUnlockManager managerForOfferSource:offerSource
                                                         error:&err];
            
            if (_unlockManager == nil) {
                NSLog(@"An error occurred while initializing AGUUnlock. Offers and redeemed features will not be available.");
                if (err != nil) {
                    NSLog(@"Error: %@", err.localizedDescription);
                }
            }
        }

    }
    return self;
}

- (NSArray<AGUFeature*>*)features
{
    NSArray<AGUFeature*>* retVal = [_unlockManager features];
    return retVal ? retVal : @[];
}

- (NSArray<AGUOffer*>*)pendingOffers
{
    NSArray<AGUOffer*>* retVal = [_unlockManager pendingOffers];
    return retVal ? retVal : @[];
}

- (void)consumeOffer:(nonnull AGUOffer*)offer
{
    if ([offer.unlockMessage length] > 0)
    {
        // Replace $nickname with the nickname found in the custom payload, if applicable
        NSString *message = offer.unlockMessage;
        NSString *customNickname = offer.data[@"nickname"];
        if ([customNickname isKindOfClass:[NSString class]] && [customNickname length] > 0) {
            message = [message stringByReplacingOccurrencesOfString:@"$nickname" withString:customNickname];
        }
        [self showSimpleAlertForMessage:message];
    }
    
    // Features will be remembered by the manager,
    // but we need to take care of the resources here before marking the offer as consumed
    for (AGUResource *resource in [offer resources]) {
        [_resourceManager addQuantity:resource.quantity forResource:[resource.name uppercaseString]];
    }
    
    [_unlockManager consumeOffer:offer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSampleUnlockManagerUpdatedNotification object:nil];
}

- (void)showSimpleAlertForMessage:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unlock Sample"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    UIViewController *targetVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    UIViewController *presentedVC = targetVC.presentedViewController;
    if (presentedVC != nil) {
        targetVC = presentedVC;
    }
    [targetVC presentViewController:alert animated:YES completion:nil];
}

@end
