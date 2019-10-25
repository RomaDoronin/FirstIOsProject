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
#import "FindTableViewCell.h"

@interface FindViewController () {
@private
    NewsSet *filteredNewsSet;
    BOOL isFiltered;
}

@end

@implementation FindViewController

- (id)init {
    if (self = [super init]) {
        isFiltered = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    static NSString *cellId = @"customCell";
    FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NewsSet *outputSet;
    
    if (isFiltered) {
        outputSet = filteredNewsSet;
    }
    else {
        outputSet = self.newsSet;
    }
    
    NewsPost *post = [outputSet getAtIndex:indexPath.row];
    UIImage *image = [UIImage imageWithData:post.realImage];
    const NSInteger kImageSize = 80;    
    UIImage *resizeImage = [ResizeImages resizeImage:image KeepingProportionByOneSide:kImageSize];
    
    cell.imageFind.image = resizeImage;
    cell.lableFindTitle.text = [outputSet getAtIndex:indexPath.row].title;
    cell.lableFindDetail.text = [outputSet getAtIndex:indexPath.row].subtitle;
    
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (searchText.length == 0) {
            isFiltered = NO;
        }
        else {
            NewsSet *newsSetCopy = self.newsSet.getCopy;
            
            isFiltered = YES;
            filteredNewsSet = [[NewsSet alloc] init];
        
            for (long count = 0; count < [newsSetCopy getCount]; count++) {
                // Search for title
                NewsPost *post = [newsSetCopy getAtIndex:count];
                NSRange nameRange = [post.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (nameRange.location != NSNotFound) {
                    [filteredNewsSet addNews:post];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.findTable reloadData];
        });
    });
}

@end
