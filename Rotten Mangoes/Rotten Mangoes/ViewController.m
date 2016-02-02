//
//  ViewController.m
//  Rotten Mangoes
//
//  Created by Carl Udren on 2/1/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "Movie.h"
#import "DetailViewController.h"

#pragma Mark - Contants

#define MINIMUM_ITEM_SPACING 20
#define EDGE_INSET_SYMETRIC 20
#define HEADER_HEIGHT 50

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *movieData;

@end

@implementation ViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self prepareCollectionView];
    [self prepareMovieData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movieData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Movie *movie = self.movieData[indexPath.row];
    cell.movie = movie;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Movie *movie = self.movieData[indexPath.row];
    DetailViewController *viewController = [[DetailViewController alloc] init];
    viewController.movie = movie;
    
    [self presentViewController:viewController animated:YES completion:nil];

}


- (void) prepareCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = MINIMUM_ITEM_SPACING;
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 2 - 30, self.view.frame.size.height / 3);
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, HEADER_HEIGHT);
    flowLayout.sectionInset = UIEdgeInsetsMake(EDGE_INSET_SYMETRIC,EDGE_INSET_SYMETRIC,EDGE_INSET_SYMETRIC,EDGE_INSET_SYMETRIC);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:flowLayout];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.userInteractionEnabled = YES;
    [self.view addSubview:self.collectionView];
}

- (void) prepareMovieData {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=2ckft9dtnazuw4ks5qq3uhzu&page_limit=50"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSError *jsonParsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if (!jsonParsingError) {
                NSLog(@"%@", jsonData);
                
                NSMutableArray *movieList = [NSMutableArray array];
                for (NSDictionary *movieDictionary in jsonData[@"movies"]) {
                    Movie *movie = [[Movie alloc] init];
                    movie.title = movieDictionary[@"title"];
                    movie.imageURLString = movieDictionary[@"posters"][@"profile"];
                    movie.RT_idNumber = movieDictionary[@"id"];
                    movie.score = [movieDictionary[@"ratings"][@"critics_score"] integerValue];
                    
                    [movieList addObject:movie];
                }
                
                self.movieData = [movieList copy];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Inside dispatch async");
                    [self.collectionView reloadData];
                });
                NSLog(@"After dispatch async");
            }
            
        }
        
    }];
    [task resume];

    }

@end
