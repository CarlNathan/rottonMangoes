//
//  DetailViewController.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) UILabel *quote1;
@property (strong, nonatomic) UILabel *quote2;
@property (strong, nonatomic) UILabel *quote3;
@property (strong, nonatomic) UILabel *critic1;
@property (strong, nonatomic) UILabel *critic2;
@property (strong, nonatomic) UILabel *critic3;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    [photoController imageForPhoto:self.movie.imageURLString completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    [ReviewsController ReviewsForMovie:self.movie completion:^(NSArray *reviewArray) {
        self.reviews = reviewArray;
        [self prepareReviewView];
    }];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGSize size= self.view.bounds.size;
    CGSize imagesize = CGSizeMake(size.width, 500);
    self.scrollView.contentSize = CGSizeMake(size.width, size.height *2);

    
    self.imageView.frame = CGRectMake(0.0, 20, imagesize.width, imagesize.height);
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) prepareReviewView{
    
    self.reviewView  = [[UIView alloc] initWithFrame:CGRectMake(0, 500, 500, 800)];
    
    self.quote1  = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 30)];
    self.critic1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 300, 30)];
    
    self.quote2  = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 30)];
    self.critic2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 300, 30)];
    
    self.quote3  = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 300, 30)];
    self.critic3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 300, 30)];
    
    
    [self.reviewView addSubview:self.quote1];
    [self.reviewView addSubview:self.critic1];
    [self.reviewView addSubview:self.quote2];
    [self.reviewView addSubview:self.critic2];
    [self.reviewView addSubview:self.quote3];
    [self.reviewView addSubview:self.critic3];
    
    Review *review1 = self.reviews[0];
    self.quote1.text = review1.quote;
    NSString *criticString1 = [NSString stringWithFormat:@"%@ - %@", review1.critic, review1.publication];
    self.critic1.text = criticString1;
    
    Review *review2 = self.reviews[1];
    self.quote2.text = review2.quote;
    NSString *criticString2 = [NSString stringWithFormat:@"%@ - %@", review2.critic, review2.publication];
    self.critic2.text = criticString2;

    
    Review *review3 = self.reviews[2];
    self.quote3.text = review3.quote;
    NSString *criticString3 = [NSString stringWithFormat:@"%@ - %@", review3.critic, review3.publication];
    self.critic3.text = criticString3;
    
    [self.scrollView addSubview:self.reviewView];


}


@end
