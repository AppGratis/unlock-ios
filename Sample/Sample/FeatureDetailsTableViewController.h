//
//  FeatureDetailsTableViewController.h
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 14/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AGUUnlock;

@interface FeatureDetailsTableViewController : UITableViewController

@property (nonatomic) AGUFeature *feature;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialLifetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;

@end
