//
//  ReviewView.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "ReviewView.h"

@interface ReviewView ()

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ReviewView

- (void) prepareReviewViewWithReviews:(NSArray *) reviews{
    

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.scrollView];
    
    
    Review *review1 = reviews[0];
    [self setUpSubView:review1 AtLocation:0];
    Review *review2 = reviews[1];
    [self setUpSubView:review2 AtLocation:1];
    Review *review3 = reviews[2];
    [self setUpSubView:review3 AtLocation:2];
    
    
}

- (void) setUpSubView: (Review *)review AtLocation: (NSInteger) index{
    UIView *reviewSubView = [[UIView alloc] init];
    
    CGSize size = self.scrollView.bounds.size;
    
    UILabel *critic  = [[UILabel alloc] initWithFrame:CGRectMake(20 + (size.width * index), 20, size.width - 40, 30)];
    UILabel *quote = [[UILabel alloc] initWithFrame:CGRectMake(20 + (size.width * index), 50, size.width - 40, 200)];

    
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


@end
