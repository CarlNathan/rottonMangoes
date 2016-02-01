//
//  CollectionViewCell.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(void)setMovie:(Movie *)movie{
    _movie = movie;
    
    [photoController imageForPhoto:self.movie.imageURLString completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}


@end
