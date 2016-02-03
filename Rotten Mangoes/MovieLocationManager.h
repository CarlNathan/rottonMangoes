//
//  MovieLocationManager.h
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/2/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "Theater.h"


@interface MovieLocationManager : NSObject

+ (void)locationsForMovie:(Movie *)movie AtPostalCode: (NSString *) postalCode completion:(void(^)(NSArray *locastionArray))completion;
@end
