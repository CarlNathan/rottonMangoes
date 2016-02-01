//
//  photoController.h
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface photoController : NSObject

+ (void)imageForPhoto:(NSString *)urlString completion:(void(^)(UIImage *image))completion;
@end
