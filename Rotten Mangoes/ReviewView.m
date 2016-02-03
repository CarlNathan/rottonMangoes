//
//  ReviewView.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "ReviewView.h"

@interface ReviewView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation ReviewView

- (void) prepareReviewViewWithReviews:(NSArray *) reviews{
    

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    
    Review *review1 = reviews[0];
    [self setUpSubView:review1 AtLocation:0];
    Review *review2 = reviews[1];
    [self setUpSubView:review2 AtLocation:1];
    Review *review3 = reviews[2];
    [self setUpSubView:review3 AtLocation:2];
    
    [self preparePageControl];
    
    
}

- (void) setUpSubView: (Review *)review AtLocation: (NSInteger) index{
    UIView *reviewSubView = [[UIView alloc] init];
    
    CGSize size = self.scrollView.bounds.size;
    
    UILabel *critic  = [[UILabel alloc] initWithFrame:CGRectMake(20 + (size.width * index), 20, size.width - 40, 30)];
    UILabel *quote = [[UILabel alloc] initWithFrame:CGRectMake(20 + (size.width * index), 50, size.width - 40, 170)];

    
    quote.text = review.quote;
    NSString *criticString = [NSString stringWithFormat:@"%@ - %@", review.critic, review.publication];
    critic.text = criticString;
    quote.numberOfLines = 10;
    quote.textColor = [UIColor whiteColor];
    critic.textColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:quote];
    [self.scrollView addSubview:critic];
    
    [self.scrollView addSubview:reviewSubView];
    
}

- (void) preparePageControl {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50, self.frame.size.height - 80, 100, 50)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    float offset = self.scrollView.contentOffset.x + self.frame.size.width/2;
    if (offset > self.frame.size.width * 2) {
        self.pageControl.currentPage = 2;
    } else if (offset > self.frame.size.width) {
        self.pageControl.currentPage = 1;
    } else {
        self.pageControl.currentPage = 0;
    }
}


@end
