//
//  ReviewsController.h
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
#import "Review.h"

@interface ReviewsController : NSObject

+ (void)ReviewsForMovie:(Movie *)movie completion:(void(^)(NSArray *reviewArray))completion;

@end
