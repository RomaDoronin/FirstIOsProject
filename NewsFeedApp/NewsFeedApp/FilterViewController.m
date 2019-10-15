//
//  FilterViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 14.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "FilterViewController.h"
#import "DetailViewController.h"

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
    newsSource = @[@"BBC", @"Mashable", @"Chet.com", @"Hipertextual.com", @"The Next Web"];
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
        cell.imageView.image = [UIImage imageNamed:[filteredNewsSet getAtIndex:indexPath.row].image];
        cell.textLabel.text = [filteredNewsSet getAtIndex:indexPath.row].title;
        cell.detailTextLabel.text = [filteredNewsSet getAtIndex:indexPath.row].source;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController * detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detaiView"];
    
    detailView.newsPost = [filteredNewsSet getAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailView animated:YES];
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
    return [NSString stringWithFormat:@"%@", [newsSource objectAtIndex:row]];
}

- (IBAction)filterActionButton:(UIBarButtonItem *)sender {
    NSString * searchSource = [newsSource objectAtIndex:pickerCurrRow];
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
