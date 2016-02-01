//
//  DetailViewController.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:self.imageView];
    
    [photoController imageForPhoto:self.movie.imageURLString completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    [ReviewsController ReviewsForMovie:self.movie completion:^(NSArray *reviewArray) {
        self.reviews = reviewArray;
    }];
    
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGSize size= self.view.bounds.size;
    CGSize imagesize = CGSizeMake(size.width, size.width);
    
    self.imageView.frame = CGRectMake(0.0, 20, imagesize.width, imagesize.height);
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
