//
//  FeatureDetailsTableViewController.m
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 14/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import "FeatureDetailsTableViewController.h"

@interface FeatureDetailsTableViewController ()

@end

@implementation FeatureDetailsTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.nameLabel.text = self.feature.name;
    self.initialLifetimeLabel.text = self.feature.isTimeLimited ? [self stringForTimeInSeconds:self.feature.initialLifetime] : @"Unlimited";
    self.timeLeftLabel.text = self.feature.isTimeLimited ? [self stringForTimeInSeconds:[self.feature.remainingLifetime doubleValue]] : @"Unlimited";
}

- (NSString*)stringForTimeInSeconds:(NSTimeInterval)time
{
    return [NSString stringWithFormat:@"%ld s", (long)time];
}

@end
