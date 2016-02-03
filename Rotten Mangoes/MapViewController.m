//
//  MapViewController.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/2/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "MapViewController.h"
#import "MovieLocationManager.h"

@interface MapViewController ()

@property (assign, nonatomic) BOOL initialLocationSet;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) NSArray *movieLocations;

@end

@implementation MapViewController

- (instancetype) initWithMovie: (Movie*) movie {
    self = [super init];
    if (self) {
        _movie = movie;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initialLocationSet = NO;
    
    [self prepareMapView];
}


- (void) prepareMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
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
        MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, MKCoordinateSpanMake(0.02, 0.02));
        
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
        for (MKPointAnnotation *annotation in self.movieLocations) {
            [self.mapView addAnnotation:annotation];

        }
    }];
}
        
@end
