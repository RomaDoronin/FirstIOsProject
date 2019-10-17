//
//  FindViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 14.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "FindViewController.h"
#import "DetailViewController.h"
#import "ResizeImages.h"

@interface FindViewController () {
@private
    NewsSet *filteredNewsSet;
    BOOL isFiltered;
}

@end

static const NSInteger kImageSize = 70;

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFiltered = NO;
    self.searchBar.delegate = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered)
    {
        return [filteredNewsSet getCount];
    }
    else {
        return [self.newsSet getCount];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"findCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (isFiltered) {
        cell.imageView.image = [ResizeImages imagesWithImage:[UIImage imageWithData:[filteredNewsSet getAtIndex:indexPath.row].realImage] scaledToSize:CGSizeMake(kImageSize, kImageSize)];
        cell.textLabel.text = [filteredNewsSet getAtIndex:indexPath.row].title;
        cell.detailTextLabel.text = [filteredNewsSet getAtIndex:indexPath.row].subtitle;
    }
    else {
        cell.imageView.image = [ResizeImages imagesWithImage:[UIImage imageWithData:[self.newsSet getAtIndex:indexPath.row].realImage] scaledToSize:CGSizeMake(kImageSize, kImageSize)];
        cell.textLabel.text = [self.newsSet getAtIndex:indexPath.row].title;
        cell.detailTextLabel.text = [self.newsSet getAtIndex:indexPath.row].subtitle;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController * detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detaiView"];
    
    if (isFiltered)
    {
        detailView.newsPost = [filteredNewsSet getAtIndex:indexPath.row];
    }
    else {
        detailView.newsPost = [self.newsSet getAtIndex:indexPath.row];
    }
        
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isFiltered = NO;
    }
    else {
        isFiltered = YES;
        filteredNewsSet = [[NewsSet alloc] init];
        
        for (long count = 0; count < [self.newsSet getCount]; count++) {
            // Search for title
            NewsPost *post = [self.newsSet getAtIndex:count];
            NSRange nameRange = [post.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [filteredNewsSet addNews:post];
            }
        }
    }
    
    [self.findTable reloadData];
}

@end
