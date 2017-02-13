//
//  UnlockSampleTableViewController.h
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 10/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AGUUnlock;

#import "ResourceManager.h"

@interface UnlockSampleTableViewController : UITableViewController

@end

@interface RedeemedFeaturesDatasource : NSObject
{
    NSArray<AGUFeature*> *_features;
}

- (instancetype)initWithFeatures:(NSArray<AGUFeature*>*)features;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row;

- (NSInteger)numberOfRows;

@end


@interface AvailableOffersDatasource : NSObject
{
    NSArray<AGUOffer*> *_offers;
}

- (instancetype)initWithOffers:(NSArray<AGUOffer*>*)offers;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row;

- (NSInteger)numberOfRows;

@end

@interface ResourcesDatasource : NSObject
{
    ResourceManager *_resourceManager;
    NSArray<NSString*> *_knownResources;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row;

- (NSInteger)numberOfRows;

@end
