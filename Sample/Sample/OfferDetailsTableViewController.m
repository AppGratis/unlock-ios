//
//  OfferDetailsTableViewController.m
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 13/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import "OfferDetailsTableViewController.h"

#import "SampleUnlockManager.h"

@interface OfferDetailsTableViewController ()

@end

@implementation OfferDetailsTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tokenLabel.text = self.offer.token;
    self.featuresLabel.text = [NSString stringWithFormat:@"%ld", (long)self.offer.features.count];
    self.resourcesLabel.text = [NSString stringWithFormat:@"%ld", (long)self.offer.resources.count];
}

- (IBAction)redeem:(id)sender
{
    if (self.offer) {
        [[SampleUnlockManager sharedInstance] consumeOffer:self.offer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
