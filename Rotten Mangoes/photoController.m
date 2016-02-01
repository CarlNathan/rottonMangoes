//
//  photoController.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "photoController.h"

@implementation photoController


+ (void)imageForPhoto:(NSString *)urlString completion:(void(^)(UIImage *image))completion{
    
    if (urlString == nil || completion == nil) {
        return;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:[location path]];
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    [task resume];}


@end
