//
//  SearchViewController.m
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchResultViewController.h"
#import "LocationObject.h"

#import "PlaceCell.h"
#import "ChooseOnMapView.h"
#import "Utils.h"

#import "MBProgressHUD.h"

@interface SearchViewController () <UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,GMSAutocompleteFetcherDelegate,SearchResultViewControllerDelegate,ChooseOnMapViewDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultViewController *searchResultViewController;

@property (nonatomic, strong) GMSAutocompleteFetcher *autocompleteFetcher;

@property (nonatomic, strong) UIBarButtonItem *barBtnBack;
@property (nonatomic, weak) IBOutlet UITableView *tblListLocation;

@property (nonatomic, strong) NSArray *arrListLocation;


@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self setupData];
}

#pragma mark - SelectPlace

- (void)didSelectPlace:(GMSAutocompletePrediction *)info
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    GMSPlacesClient *placesClient = [GMSPlacesClient sharedClient];
    [placesClient lookUpPlaceID:info.placeID callback:^(GMSPlace *place, NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        
        if (error || !place) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"An error occurred. Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        
        LocationObject *locationObj = [[LocationObject alloc] initWithLocation:place];
        if (!locationObj) return;

        [self didSelectLocation:locationObj];
    }];
}

- (void)didSelectOpenMap
{
    [self onBack];
}

- (void)didSelectChoosePlaceOnMap
{
    [self onBack];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

- (void)didDismissSearchController:(UISearchController *)searchController {
    SearchResultViewController *vc = (SearchResultViewController *)searchController.searchResultsController;
    [vc setResult:nil];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *sSearch = [searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (sSearch.length <= 0) return;
    
    [self.autocompleteFetcher sourceTextHasChanged:sSearch];
    [Utils setIsShowNetworkIndicator:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrListLocation.count;
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
    
    LocationObject *locationObj = self.arrListLocation[indexPath.row];
    [placeCell configWithLocation:locationObj];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell isKindOfClass:[PlaceCell class]]) return;
    
    PlaceCell *placeCell = (PlaceCell *)cell;
    [placeCell emptyView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationObject *locationObj = self.arrListLocation[indexPath.row];
    [self didSelectLocation:locationObj];
}

#pragma mark - SetupData

- (void)setupData
{
    self.autocompleteFetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:nil filter:nil];
    self.autocompleteFetcher.delegate = self;
    
    self.arrListLocation = [self getHistorySearch];
    [self.tblListLocation reloadData];
}

- (void)didAutocompleteWithPredictions:(GMS_NSArrayOf(GMSAutocompletePrediction *) *)predictions {
    SearchResultViewController *vc = (SearchResultViewController *)self.searchController.searchResultsController;
    [vc setResult:predictions];

    [Utils setIsShowNetworkIndicator:NO];
}

- (void)didFailAutocompleteWithError:(NSError *)error {
    [Utils setIsShowNetworkIndicator:NO];
}

- (NSArray *)getHistorySearch
{
    NSMutableArray *listLocation = [[NSMutableArray alloc] init];
    
    for (NSDictionary *locationInfo in [[NSUserDefaults standardUserDefaults] objectForKey:HISTORY_SEARCH]) {
        LocationObject *location = [[LocationObject alloc] initWithInfo:locationInfo];
        if (!location) continue;
        
        [listLocation addObject:location];
    }
    
    return [listLocation copy];
}

- (void)didSelectLocation:(LocationObject *)locationObj
{
    if ([self.delegate respondsToSelector:@selector(didSelectLocation:isStartLocation:)]) {
        [self addLocationToHistorySearch:locationObj];
        [self.delegate didSelectLocation:locationObj isStartLocation:self.isSearchForStartLocation];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLocationToHistorySearch:(LocationObject *)newLocation
{
    NSMutableArray *listLocation = [[NSMutableArray alloc] initWithArray:self.arrListLocation];
    for (LocationObject *location in self.arrListLocation) {
        if ([location.placeID isEqualToString:newLocation.placeID]) {
            [listLocation removeObject:location];
        }
    }
    [listLocation insertObject:newLocation atIndex:0];
    
    NSMutableArray *arrHistorySearch = [NSMutableArray new];
    for (LocationObject *location in listLocation) {
        NSMutableDictionary *locationInfo = [NSMutableDictionary new];
        
        [locationInfo setObject:location.placeID forKey:@"placeID"];
        [locationInfo setObject:location.name forKey:@"name"];
        [locationInfo setObject:location.address forKey:@"address"];
        [locationInfo setObject:@(location.coordinate.latitude) forKey:@"lat"];
        [locationInfo setObject:@(location.coordinate.longitude) forKey:@"long"];
        
        [arrHistorySearch addObject:locationInfo];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrHistorySearch forKey:HISTORY_SEARCH];
}

#pragma mark - SetupUI

- (void)setupUI
{
    self.searchResultViewController = [[SearchResultViewController alloc] init];
    self.searchResultViewController.delegate = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultViewController];
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    
    self.definesPresentationContext = YES;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    [self.searchController.searchBar sizeToFit];
    [self.searchController.searchBar setPlaceholder:@"Search address or place"];
    
    self.navigationItem.title = @"Search Location";
    self.navigationItem.leftBarButtonItem = self.barBtnBack;
    self.navigationItem.hidesBackButton = YES;
    
    UITableView *tblHeader = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 94.0) style:UITableViewStylePlain];
    [tblHeader setTableHeaderView:self.searchController.searchBar];
    
    ChooseOnMapView *chooseOnMapView = [Utils loadView:[ChooseOnMapView class] fromXib:@"ChooseOnMapView"];
    chooseOnMapView.delegate = self;
    [tblHeader setTableFooterView:chooseOnMapView];
    
    [self.tblListLocation setTableHeaderView:tblHeader];
    [self.tblListLocation setTableFooterView:[UIView new]];
    [self.tblListLocation registerNib:[UINib nibWithNibName:@"PlaceCell" bundle:nil] forCellReuseIdentifier:@"PlaceCellId"];
}

- (UIBarButtonItem *)barBtnBack
{
    if (!_barBtnBack) {
        _barBtnBack = [Utils customBackNavigationWithTarget:self selector:@selector(onBack)];
    }
    return _barBtnBack;
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self.searchController.view removeFromSuperview];
}

@end
