//
//  DetailViewController.h
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "photoController.h"
#import "ReviewsController.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *reviews;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *reviewView;

@end
