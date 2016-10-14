//
//  SearchResultViewController.m
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import "SearchResultViewController.h"

#import "PlaceCell.h"
#import "ChooseOnMapView.h"

#import "Utils.h"

@interface SearchResultViewController () <ChooseOnMapViewDelegate>

@property (nonatomic, strong) NSArray *listPlace;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ChooseOnMapView *chooseOnMapView = [Utils loadView:[ChooseOnMapView class] fromXib:@"ChooseOnMapView"];
    chooseOnMapView.delegate = self;
    [self.tableView setTableHeaderView:chooseOnMapView];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceCell" bundle:nil] forCellReuseIdentifier:@"PlaceCellId"];
}

- (void)setResult:(NSArray *)result
{
    self.listPlace = result;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listPlace.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PlaceCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:@"PlaceCellId" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![cell isKindOfClass:[PlaceCell class]]) return;
    
    PlaceCell *placeCell = (PlaceCell *)cell;
    
    GMSAutocompletePrediction *place = self.listPlace[indexPath.row];
    [placeCell configWithInfo:place];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell isKindOfClass:[PlaceCell class]]) return;
    
    PlaceCell *placeCell = (PlaceCell *)cell;
    [placeCell emptyView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectPlace:)]) {
        GMSAutocompletePrediction *place = self.listPlace[indexPath.row];
        [self.delegate didSelectPlace:place];
    }
}

- (void)didSelectChoosePlaceOnMap
{
    if ([self.delegate respondsToSelector:@selector(didSelectOpenMap)]) {
        [self.delegate didSelectOpenMap];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
