//
//  TheaterDetailViewController.h
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/2/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"


@interface TheaterDetailViewController : UIViewController

@property (strong, nonatomic) Movie *movie;

- (instancetype)initWithMovie: (Movie *) movie;


@end
