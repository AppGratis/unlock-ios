//
//  OfferDetailsTableViewController.h
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 13/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AGUUnlock;

@interface OfferDetailsTableViewController : UITableViewController

@property (nonatomic) AGUOffer *offer;

@property (weak, nonatomic) IBOutlet UILabel *tokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *featuresLabel;
@property (weak, nonatomic) IBOutlet UILabel *resourcesLabel;

@end
