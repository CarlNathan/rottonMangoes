//
//  ReviewsController.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "ReviewsController.h"

@implementation ReviewsController

+ (void)ReviewsForMovie:(Movie *)movie completion:(void(^)(NSArray *reviewArray))completion{
    
    if (movie.RT_idNumber == nil || completion == nil) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies/%@/reviews.json?apikey=j9fhnct2tp8wu2q9h75kanh9&page_limit=3", movie.RT_idNumber];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                NSLog(@"%@", jsonData);
                
                NSMutableArray *reviewList = [NSMutableArray array];
                for (NSDictionary *reviewDictionary in jsonData[@"reviews"]) {
                    Review *review = [[Review alloc] init];
                    review.publication = reviewDictionary[@"publication"];
                    review.quote = reviewDictionary[@"quote"];
                    review.critic = reviewDictionary[@"critic"];
                    
                    [reviewList addObject:review];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion([reviewList copy]);            });
        }
            return;
    }
        return;
    }];
    
                
    [task resume];}


@end
