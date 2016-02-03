//
//  DetailViewController.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "DetailViewController.h"
#import "ReviewView.h"
#import "TheaterDetailViewController.h"

@interface DetailViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *reviews;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) ReviewView *reviewView;

@property (strong, nonatomic) UILabel *scoreLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20)];
    self.scrollView.delegate = self;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
    
    self.reviewView = [[ReviewView alloc] initWithFrame:CGRectMake(0, 320, 320, 320)];
    
    [photoController imageForPhoto:self.movie.imageURLString completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    [ReviewsController ReviewsForMovie:self.movie completion:^(NSArray *reviewArray) {
        self.reviews = reviewArray;
        [self.reviewView prepareReviewViewWithReviews:self.reviews];
        [self.scrollView addSubview:self.reviewView];
    }];
    
    [self prepareScoreLabel];
    
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft)];
    [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:swipeLeft];
    
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGSize size= self.view.bounds.size;
    self.scrollView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
    CGSize imagesize = CGSizeMake(size.width, 500);
    self.imageView.frame = CGRectMake(0.0, 20, imagesize.width, imagesize.height);
    self.reviewView.frame = CGRectMake(0, imagesize.height + 30, size.width, 300);
    self.scrollView.contentSize = CGSizeMake(size.width, self.imageView.frame.size.height + self.reviewView.frame.size.height);

}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) prepareScoreLabel {
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", self.movie.score];
    self.scoreLabel.backgroundColor = [UIColor grayColor];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:self.scoreLabel];
}


- (void) didSwipeLeft {
    
        TheaterDetailViewController *theaterDetailViewController = [[TheaterDetailViewController alloc] initWithMovie: self.movie];
        
        [self presentViewController:theaterDetailViewController animated:YES completion:nil];
}

@end
