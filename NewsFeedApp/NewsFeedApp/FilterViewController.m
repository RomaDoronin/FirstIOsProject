//
//  FilterViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 14.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "FilterViewController.h"
#import "DetailViewController.h"
#import "ResizeImages.h"
#import "Router.h"

@interface FilterViewController () {
@private
    NSInteger pickerCurrRow;
    NewsSet *filteredNewsSet;
    BOOL isFiltered;
}

@end

@implementation FilterViewController

@synthesize newsSet;
@synthesize newsSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFiltered = NO;
    pickerCurrRow = 0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered) {
        return [filteredNewsSet getCount];
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"filterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (isFiltered) {
        cell.imageView.image = [ResizeImages imagesWithImage:[UIImage imageWithData:[filteredNewsSet getAtIndex:indexPath.row].realImage] scaledToSize:CGSizeMake(70, 70)];
        cell.textLabel.text = [filteredNewsSet getAtIndex:indexPath.row].title;
        cell.detailTextLabel.text = [filteredNewsSet getAtIndex:indexPath.row].source;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [Router goToDetailView:self NewsSet:filteredNewsSet ViewId:@"detailView" Index:indexPath.row];
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return newsSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@", newsSource[row]];
}

- (IBAction)filterActionButton:(UIBarButtonItem *)sender {
    NSString * searchSource = newsSource[pickerCurrRow];
    isFiltered = YES;
    filteredNewsSet = [[NewsSet alloc] init];
    
    for (long count = 0; count < [self.newsSet getCount]; count++) {
        NewsPost *post = [self.newsSet getAtIndex:count];
        // Search for source
        NSRange nameRange = [post.source rangeOfString:searchSource options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [filteredNewsSet addNews:post];
        }
    }
    
    [self.filterTable reloadData];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    pickerCurrRow = row;
}

@end
