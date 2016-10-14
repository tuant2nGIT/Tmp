//
//  MainViewController.m
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import "MainViewController.h"

#import "SearchViewController.h"
#import "LocationObject.h"

#import "Utils.h"

@interface MainViewController () <SearchViewControllerDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    LocationObject *startLocation, *endLocation;
    GMSMarker *startMarker, *endMarker;
    GMSPolyline *curentDirection;
    
    BOOL isGetLocation;
    CLLocationManager *locationManager;
}

@property (nonatomic, weak) IBOutlet GMSMapView *mapView;

@property (nonatomic, weak) IBOutlet UIView *searchLocationControl;
@property (nonatomic, weak) IBOutlet UIButton *btnStartLocation, *btnEndLocation;
@property (nonatomic, weak) IBOutlet UIButton *btnStartPin, *btnEndPin;

@property (nonatomic, weak) IBOutlet UIButton *btnReverseLocation;
@property (nonatomic, weak) IBOutlet UIButton *btnGetCurrentLocation;

@property (nonatomic, strong) NSOperationQueue *getRouteQueue;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self setupGetRouteQueue];
}

#pragma mark - Action

- (IBAction)touchStartLocation:(id)sender
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.delegate = self;
    vc.isSearchForStartLocation = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchEndLocation:(id)sender
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.delegate = self;
    vc.isSearchForStartLocation = NO;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectLocation:(LocationObject *)location isStartLocation:(BOOL)isStartLocation
{
    if (isStartLocation) {
        startLocation = location;
        [self moveToLocation:startLocation];
        [self markLocation:startLocation isStartLocation:YES];
    }
    else {
        endLocation = location;
        [self moveToLocation:endLocation];
        [self markLocation:endLocation isStartLocation:NO];
    }
    [self draw];
}

- (IBAction)touchReverseLocation:(id)sender
{
    LocationObject *tmpPlace = startLocation;
    
    startLocation = endLocation;
    [self markLocation:startLocation isStartLocation:YES];
    
    endLocation = tmpPlace;
    [self markLocation:endLocation isStartLocation:NO];
    
    [self draw];
}

- (void)draw
{
    NSString *sStartLocationDesc = startLocation?(startLocation.address):(@"Touch to search location...");
    [self.btnStartLocation setTitle:sStartLocationDesc forState:UIControlStateNormal];
    
    NSString *sEndLocationDesc = endLocation?(endLocation.address):(@"Touch to search location...");
    [self.btnEndLocation setTitle:sEndLocationDesc forState:UIControlStateNormal];
    
    if (startLocation && endLocation)
    {
        NSString *sUrlRequest = [NSString stringWithFormat:
                                 @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true&key=%@&mode=driving",
                                 startLocation.coordinate.latitude,
                                 startLocation.coordinate.longitude,
                                 endLocation.coordinate.latitude,
                                 endLocation.coordinate.longitude,
                                 GOOGLE_DIRECTIONS_API_KEY];
        NSURL *directionsURL = [NSURL URLWithString:sUrlRequest];
        
        NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];
        blockOperation.queuePriority = NSOperationQueuePriorityLow;
        
        __weak NSBlockOperation *weakOperation = blockOperation;
        [blockOperation addExecutionBlock:^{
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:directionsURL];
            if ([weakOperation isCancelled]) return;
            
            if (!data) {
                [self showError];
                return;
            }
            
            NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error) {
                [self showError];
                return;
            }
            
            NSString *status = json[@"status"];
            if ([status isEqualToString:@"OK"])
            {
                GMSPath *path = nil;
                @try {
                    path = [GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@",exception.description);
                }
                
                if (!path) {
                    [self showError];
                    return;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:startLocation.coordinate coordinate:endLocation.coordinate];
                    [self.mapView setCamera:[self.mapView cameraForBounds:bounds insets:UIEdgeInsetsMake(50.0, 50.0, 150.0, 50.0)]];
                    [self.mapView setSelectedMarker:nil];
                    
                    [self drawDirection:path];
                });
            }
            else if ([status isEqualToString:@"NOT_FOUND"] ||
                     [status isEqualToString:@"ZERO_RESULTS"] ||
                     [status isEqualToString:@"MAX_WAYPOINTS_EXCEEDED"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Cannot find direction on map!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                });
            }
            else if ([status isEqualToString:@"INVALID_REQUEST"] ||
                     [status isEqualToString:@"OVER_QUERY_LIMIT"] ||
                     [status isEqualToString:@"REQUEST_DENIED"] ||
                     [status isEqualToString:@"UNKNOWN_ERROR"])
            {
                [self showError];
            }
        }];
        [self addOperation:blockOperation];
    }
    else if (startLocation && !endLocation) {
        [self.mapView setCamera:[GMSCameraPosition cameraWithTarget:startLocation.coordinate zoom:16]];
        [self.mapView setSelectedMarker:startMarker];
    }
    else if (!startLocation && endLocation) {
        [self.mapView setCamera:[GMSCameraPosition cameraWithTarget:endLocation.coordinate zoom:16]];
        [self.mapView setSelectedMarker:endMarker];
    }
}

- (void)moveToLocation:(LocationObject *)location
{
    [self.mapView animateToLocation:location.coordinate];
}

- (void)markLocation:(LocationObject *)location isStartLocation:(BOOL)isStartLocation
{
    GMSMarker *marker = [GMSMarker markerWithPosition:location.coordinate];
    marker.icon = isStartLocation?[UIImage imageNamed:@"ic_location_pin_blue"]:[UIImage imageNamed:@"ic_location_pin_red"];
    if (location.address) {
        marker.title = location.name;
    }
    
    if (isStartLocation)
    {
        if (startMarker) {
            startMarker.map = nil;
            startMarker = nil;
        }
        
        startMarker = marker;
        startMarker.map = self.mapView;
    }
    else {
        if (endMarker) {
            endMarker.map = nil;
            endMarker = nil;
        }
        
        endMarker = marker;
        endMarker.map = self.mapView;
    }
}

- (void)drawDirection:(GMSPath *)path
{
    if (curentDirection) {
        curentDirection.map = nil;
        curentDirection = nil;
    }
    
    curentDirection = [GMSPolyline polylineWithPath:path];
    curentDirection.strokeWidth = 4;
    curentDirection.strokeColor = [Utils colorWithRGBHex:0x017ee6];
    curentDirection.map = self.mapView;
}

#pragma mark - GetUserLocation

- (IBAction)touchGetLocation:(id)sender
{
    isGetLocation = NO;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    BOOL isEnableLocationServices = [CLLocationManager locationServicesEnabled];
    BOOL isDeniedLocationServices = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied;
    
    if (!isEnableLocationServices || isDeniedLocationServices)
    {
        [[[UIAlertView alloc] initWithTitle:@"Từ chối truy cập Vị trí" message:@"Ứng dụng yêu cầu truy cập dữ liệu Vị trí của thiết bị" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    else {
        [locationManager startUpdatingLocation];
    }
}

- (void)stopGetLocation
{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (isGetLocation) return;
    isGetLocation = NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (isGetLocation) return;
    
    if (newLocation != nil)
    {
        isGetLocation = YES;
        
        LocationObject *locationObj = [[LocationObject alloc] init];
        locationObj.name = @"Vị trí của bạn";
        locationObj.address = @"Vị trí của bạn";
        locationObj.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        
        [self stopGetLocation];
        [self didSelectLocation:locationObj isStartLocation:YES];
    }
}

#pragma mark - Queue

- (void)setupGetRouteQueue
{
    self.getRouteQueue = [[NSOperationQueue alloc] init];
    self.getRouteQueue.name = @"queue.getroute";
    self.getRouteQueue.maxConcurrentOperationCount = 1;
}

- (void)cancelAllOperation
{
    [self.getRouteQueue cancelAllOperations];
}

- (void)addOperation:(NSOperation *)operation
{
    [self cancelAllOperation];
    [self.getRouteQueue addOperation:operation];
}

#pragma mark - SetupUI

- (void)setupUI
{
    self.navigationItem.title = @"Apota Direction";
    
    self.searchLocationControl.backgroundColor = [UIColor whiteColor];
    self.searchLocationControl.layer.cornerRadius = 5.0;
    self.searchLocationControl.layer.shadowOffset = CGSizeMake(3, 3);
    self.searchLocationControl.layer.shadowRadius = 5.0;
    self.searchLocationControl.layer.shadowOpacity = 0.5;
    self.searchLocationControl.layer.masksToBounds = NO;
    self.searchLocationControl.alpha = 0.95;
    
    self.mapView.delegate = self;
    
    [self configLocationButton:self.btnStartLocation];
    self.btnStartPin.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self configLocationButton:self.btnEndLocation];
    self.btnEndPin.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)configLocationButton:(UIButton *)button
{
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
    button.clipsToBounds = YES;
}

- (void)showError
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:nil message:@"An error occurred. Please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
