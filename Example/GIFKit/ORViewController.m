//
//  ORViewController.m
//  GIFKit
//
//  Created by Orta Therox on 07/01/2014.
//  Copyright (c) 2014 Orta Therox. All rights reserved.
//

#import "ORViewController.h"
#import <GIFKit/ORRedditSearchNetworkModel.h>
#import <GIFKit/GIF.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>

@interface ORViewController ()
@property (nonatomic, copy, readonly) NSString *query;
@property (nonatomic, weak, readwrite) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong, readonly) ORRedditSearchNetworkModel *networkModel;
@end

@implementation ORViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _query = @"cats";
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"GIFCell"];

    _networkModel = [[ORRedditSearchNetworkModel alloc] init];
    self.networkModel.searchQuery = self.query;
    
    [self.networkModel getNextGIFs: ^(NSArray *newGIFs, NSError *error){
        [self.collectionView reloadData];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.networkModel.numberOfGifs;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GIFCell" forIndexPath:indexPath];
    GIF *gif = [self.networkModel gifAtIndex:indexPath.row];

    FLAnimatedImage *image = [[FLAnimatedImage alloc] initWithURLForProgressiveGIF:gif.downloadURL];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:cell.bounds];
    imageView.animatedImage = image;
    imageView.backgroundColor = [UIColor grayColor];
    
    [cell addSubview:imageView];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if((scrollView.contentSize.height - scrollView.contentOffset.y) < scrollView.bounds.size.height) {
        [self.networkModel getNextGIFs: ^(NSArray *newGIFs, NSError *error){
            [self.collectionView reloadInputViews];
        }];
    }
}

@end
