//
//  WorldViewController.m
//  Fish
//
//  Created by Thanh Pham on 11/28/15.
//  Copyright © 2015 Thanh Pham. All rights reserved.
//

#import "WorldViewController.h"
#import "World.h"
#import "Lake.h"
#import "Fish.h"
#import "FishSpecies.h"
#import "Clock.h"
#import "FoodPackage.h"
#import "FishTableViewCell.h"
#import "FishSpeciesTableHeaderView.h"
#import "AddFishSpeciesViewController.h"
#import "WorldTableHeaderView.h"

static NSString *const FishCellIdentifier = @"FishCellIdentifier";
static NSString *const FishSpeciesTableHeaderViewIdentifier = @"FishSpeciesTableHeaderViewIdentifier";

@interface WorldViewController () <FishSpeciesTableHeaderViewDelegate, FishTableViewCellDelegate> {
    UIBarButtonItem *feedButton;
    UIBarButtonItem *autoButton;
    WorldTableHeaderView *worldTableHeaderView;
}

@end

@implementation WorldViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        feedButton = [[UIBarButtonItem alloc] initWithTitle:@"Feed" style:UIBarButtonItemStylePlain target:self action:@selector(feedButtonTapped)];
        autoButton = [[UIBarButtonItem alloc] initWithTitle:@"Auto" style:UIBarButtonItemStylePlain target:self action:@selector(autoButtonTapped)];
        worldTableHeaderView = [[WorldTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ClockTickNotification object:_world];
}

#pragma mark - UIViewController life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[FishTableViewCell class] forCellReuseIdentifier:FishCellIdentifier];
    [self.tableView registerClass:[FishSpeciesTableHeaderView class] forHeaderFooterViewReuseIdentifier:FishSpeciesTableHeaderViewIdentifier];
    self.tableView.allowsSelection = NO;
    self.navigationItem.leftBarButtonItems = @[feedButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL], autoButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    [self updateTitle];
    self.tableView.tableHeaderView = worldTableHeaderView;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tick) name:ClockTickNotification object:nil];
}

#pragma mark - setters and getters

- (void)setWorld:(World *)world {
    _world = world;
    [self updateTitle];
    worldTableHeaderView.world = world;
    [self.tableView reloadData];
}

#pragma mark - UITableView related methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_world.lake.fishSpeciesList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_world.lake fishListOfSpecies:_world.lake.fishSpeciesList[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FishSpecies *species = _world.lake.fishSpeciesList[indexPath.section];
    Fish *fish = [_world.lake fishListOfSpecies:species][indexPath.row];

    FishTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:FishCellIdentifier];
    cell.delegate = self;
    cell.fish = fish;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FishSpeciesTableHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:FishSpeciesTableHeaderViewIdentifier];
    headerView.delegate = self;
    headerView.species = _world.lake.fishSpeciesList[section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.f;
}

#pragma mark - NSNotificationCenter related methods

- (void)tick {
    [self updateTitle];
    [self.tableView reloadData];
}

#pragma mark - FishSpeciesTableHeaderViewDelegate

- (void)fishSpeciesTableHeaderViewAddButtonTapped:(FishSpeciesTableHeaderView *)fishSpeciesTableHeaderView {
    [_world.lake addFish:[[Fish alloc] initWithSpecies:fishSpeciesTableHeaderView.species]];
    [self.tableView reloadData];
}

#pragma mark - FishTableViewCellDelegte

- (void)fishTableViewCellDeleteButtonTapped:(FishTableViewCell *)fishTableViewCell {
    [_world.lake removeFish:fishTableViewCell.fish];
    [self.tableView reloadData];
}

#pragma mark - "private" methods

- (void)updateTitle {
    self.title = [NSString stringWithFormat:@"%lus/%lu/%lu", (unsigned long)[Clock sharedClock].time, (unsigned long)_world.foodPackage.amount, (unsigned long)_world.lake.foodCount];
}

- (void)addButtonTapped {
    AddFishSpeciesViewController *addFishSpeciesViewController = [[AddFishSpeciesViewController alloc] initWithLake:_world.lake];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:addFishSpeciesViewController] animated:YES completion:nil];
}

- (void)feedButtonTapped {
    if ([_world.foodPackage isReady]) {
        NSUInteger foodCount = [_world.foodPackage use];
        [_world.lake addAmount:foodCount];
    }
}

- (void)autoButtonTapped {
    // TODO to be implemented
}

@end
