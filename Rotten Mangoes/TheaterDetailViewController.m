//
//  TheaterDetailViewController.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/2/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "TheaterDetailViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "Movie.h"
#import "MovieLocationManager.h"

@interface TheaterDetailViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) BOOL initialLocationSet;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSArray *movieLocations;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TheaterDetailViewController

- (instancetype) initWithMovie: (Movie*) movie {
    self = [super init];
    if (self) {
        _movie = movie;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.initialLocationSet = NO;
    
    [self prepareMapView];
    [self prepareTableView];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:swipeRight];
}


- (void) prepareMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height/2 +30)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsPointsOfInterest = NO;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.view addSubview:self.mapView];
    
}

#pragma Mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization changed");
    
    // If the user's allowed us to use their location, we can start getting location updates
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // Get the last object from the list of locations we get back
    CLLocation *userLocation = [locations lastObject];
    
    // Only do the zoom in once
    if (!self.initialLocationSet) {
        self.initialLocationSet = YES;
        
        // Create a region around the user's location
        CLLocationCoordinate2D userCoordinate = userLocation.coordinate;
        MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, MKCoordinateSpanMake(0.05, 0.05));
        
        // Tell our map view to zoom in to that region
        [self.mapView setRegion:userRegion animated:YES];
        
        // We can tell our location manager to stop updating locations
        [self.locationManager stopUpdatingLocation];
        
        // Use a CLGeocoder to determine a GPS coordinate from an address string
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error) {
                CLPlacemark *placemark = [placemarks lastObject];
                self.postalCode = placemark.postalCode;
                [self addAnnotations];
                
            }
        }];
    }
}

#pragma Mark - Map View Delegate


- (void) addAnnotations{
    [MovieLocationManager locationsForMovie:self.movie AtPostalCode:self.postalCode completion:^(NSArray *locationArray) {
        self.movieLocations = locationArray;
        NSLog(@"%@", self.movieLocations);
        for (Theater *theater in self.movieLocations) {
            [self.mapView addAnnotation:theater.annotation];
            [self.tableView reloadData];
            
        }
    }];
}

- (void) mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSInteger index = 0;
    for (Theater *theater in self.movieLocations) {
        if ([theater.annotation isEqual:view.annotation]) {
            index = [self.movieLocations indexOfObject:theater];
            break;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSInteger index = 0;
    for (Theater *theater in self.movieLocations) {
        if ([theater.annotation isEqual:view.annotation]) {
            index = [self.movieLocations indexOfObject:theater];
            break;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma Mark - TableView Data Source

- (void) prepareTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2-30, self.view.frame.size.width, self.view.frame.size.height/2+30)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movieLocations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    Theater *theater = (Theater *)self.movieLocations[indexPath.row];
    cell.textLabel.text = theater.title;
    cell.detailTextLabel.text = theater.subtitle;
    return cell;
    
}

#pragma Mark - TableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Theater *theater = (Theater *)self.movieLocations[indexPath.row];
    CLLocationCoordinate2D theaterCoordinate = theater.annotation.coordinate;
    MKCoordinateRegion theaterRegion = MKCoordinateRegionMake(theaterCoordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView setRegion:theaterRegion animated:YES];
    [self.mapView selectAnnotation:theater.annotation animated:YES];

}

- (void) didSwipeRight {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
