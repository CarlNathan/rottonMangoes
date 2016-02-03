//
//  MovieLocationManager.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/2/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "MovieLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@implementation MovieLocationManager

+ (void)locationsForMovie:(Movie *)movie AtPostalCode: (NSString *) postalCode completion:(void(^)(NSArray *locationArray))completion{
    
    if (movie.title == nil || completion == nil) {
        return;
    }
    
    NSString *originalString = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", postalCode, movie.title];
    NSString *urlString = [originalString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                NSLog(@"%@", jsonData);
                
                NSMutableArray *locationList = [NSMutableArray array];
                for (NSDictionary *locationDictionary in jsonData[@"theatres"]) {
                    MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
                    Theater *theater = [[Theater alloc] init];
                    marker.coordinate = CLLocationCoordinate2DMake([locationDictionary[@"lat"]doubleValue], [locationDictionary[@"lng"] doubleValue]);
                    marker.title = locationDictionary[@"name"];
                    theater.title = marker.title;
                    marker.subtitle = locationDictionary[@"address"];
                    theater.subtitle = marker.subtitle;
                    theater.annotation = marker;
                    
                    [locationList addObject:theater];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion([locationList copy]);            });
            }
            return;
        }
        return;
    }];
    
    
    [task resume];}




@end
