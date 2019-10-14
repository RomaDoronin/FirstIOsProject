//
//  FindViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 14.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "FindViewController.h"
#import "DetailViewController.h"

@interface FindViewController () {
    NewsSet *filteredNewsSet;
    BOOL isFiltered;
}

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFiltered = NO;
    self.searchBar.delegate = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

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
        cell.imageView.image = [UIImage imageNamed:[filteredNewsSet getAtIndex:indexPath.row].image];
        cell.textLabel.text = [filteredNewsSet getAtIndex:indexPath.row].title;
        cell.detailTextLabel.text = [filteredNewsSet getAtIndex:indexPath.row].subtitle;
    }
    else {
        cell.imageView.image = [UIImage imageNamed:[self.newsSet getAtIndex:indexPath.row].image];
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
                [filteredNewsSet addNews:post.title :post.subtitle :post.text :post.image :post.datetime];
            }
        }
    }
    
    [self.findTable reloadData];
}

@end
