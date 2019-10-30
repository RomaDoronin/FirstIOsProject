//
//  CollectionViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 15.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "DetailViewController.h"
#import "Router.h"

@interface CollectionViewController ()

@end

static NSString * const reuseIdentifier = @"gridCell";

@implementation CollectionViewController

@synthesize newsSet;

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [newsSet getCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NewsPost * post = [newsSet getAtIndex:indexPath.row];
    
    // Configure the cell
    cell.image.image = [UIImage imageWithData:post.realImage];
    cell.titleLable.text = post.title;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [Router goToDetailView:self NewsSet:newsSet ViewId:@"detailView" Index:indexPath.row];
    return YES;
}

@end
