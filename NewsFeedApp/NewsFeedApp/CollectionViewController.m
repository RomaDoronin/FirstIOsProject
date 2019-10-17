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

@interface CollectionViewController ()

@end

@implementation CollectionViewController

@synthesize newsSet;

static NSString * const reuseIdentifier = @"gridCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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
    DetailViewController * detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detaiView"];
    
    detailView.newsPost = [newsSet getAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailView animated:YES];
    return YES;
}

@end
