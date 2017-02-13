//
//  UnlockSampleTableViewController.m
//  Sample
//
//  Created by Arnaud Barisain-Monrose on 10/02/2017.
//  Copyright © 2017 iMediapp. All rights reserved.
//

#import "UnlockSampleTableViewController.h"

@import AGUUnlock;

@interface UnlockSampleTableViewController ()
{
    RedeemedFeaturesDatasource *_redeemedFeaturesDatasource;
    AvailableOffersDatasource *_pendingOffersDatasource;
    ResourcesDatasource *_resourcesDatasource;
}
@end

@implementation UnlockSampleTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _resourcesDatasource = [ResourcesDatasource new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resourceManagerDidUpdate:)
                                                 name:kSampleResourceManagerUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadDatasources];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadDatasources
{
    //TODO: Get the real values
    _redeemedFeaturesDatasource = [[RedeemedFeaturesDatasource alloc] initWithFeatures:@[]];
    _pendingOffersDatasource = [[AvailableOffersDatasource alloc] initWithOffers:@[]];
    [self.tableView reloadData];
}

- (void)resourceManagerDidUpdate:(NSNotification*)notification
{
    // No need to reload the other datasources
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Available offers";
        case 1:
            return @"Redeemed features";
        case 2:
            return @"Resources";
        default:
            return nil;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [_pendingOffersDatasource numberOfRows];
        case 1:
            return [_redeemedFeaturesDatasource numberOfRows];
        case 2:
            return [_resourcesDatasource numberOfRows];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [_pendingOffersDatasource tableView:tableView cellForRow:indexPath.row];
        case 1:
            return [_redeemedFeaturesDatasource tableView:tableView cellForRow:indexPath.row];
        case 2:
            return [_resourcesDatasource tableView:tableView cellForRow:indexPath.row];
        default:
            return nil;
    }
}

@end

@implementation RedeemedFeaturesDatasource

- (instancetype)initWithFeatures:(NSArray<AGUFeature*>*)features {
    self = [super init];
    if (self) {
        _features = features;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell"];
    if (!cell) {
        return nil;
    }
    
    cell.textLabel.text = [_features[row] name];
    
    return cell;
}

- (NSInteger)numberOfRows {
    return [_features count];
}

@end

@implementation AvailableOffersDatasource

- (instancetype)initWithOffers:(NSArray<AGUOffer*>*)offers {
    self = [super init];
    if (self) {
        _offers = offers;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell"];
    if (!cell) {
        return nil;
    }
    
    cell.textLabel.text = [_offers[row] token];
    
    return cell;
}

- (NSInteger)numberOfRows {
    return [_offers count];
}

@end

@implementation ResourcesDatasource

- (instancetype)init {
    self = [super init];
    if (self) {
        _resourceManager = [ResourceManager new];
        _knownResources = @[@"FOOD", @"GOLD"];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (!cell) {
        return nil;
    }
    
    NSString *resourceName = _knownResources[row];
    
    cell.textLabel.text = resourceName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[_resourceManager quantityForResourceNamed:resourceName]];
    
    return cell;
}

- (NSInteger)numberOfRows {
    return [_knownResources count];
}

@end
