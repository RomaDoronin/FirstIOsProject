//
//  ViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 10.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "FindViewController.h"
#import "FilterViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property NewsSet * sortedNewsSet;

@end

@implementation ViewController

@synthesize isSort;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    newSet = [[NewsSet alloc] init];
    
    [newSet addNews:@"TITLE 1"  :@"SUBTITLE 1"  :@"TEXT 1"  :@"image1" :@"2019-10-03T11:04:19Z": @"Mashable"];
    [newSet addNews:@"TITLE 2"  :@"SUBTITLE 2"  :@"TEXT 2"  :@"image2" :@"2019-11-30T11:04:19Z": @"Chet.com"];
    [newSet addNews:@"TITLE 3"  :@"SUBTITLE 3"  :@"TEXT 3"  :@"image1" :@"2019-10-15T11:04:19Z": @"BBC"];
    [newSet addNews:@"TITLE 4"  :@"SUBTITLE 4"  :@"TEXT 4"  :@"image2" :@"2019-11-28T11:04:19Z": @"Mashable"];
    [newSet addNews:@"TITLE 5"  :@"SUBTITLE 5"  :@"TEXT 5"  :@"image1" :@"2019-11-30T12:04:19Z": @"The Next Web"];
    [newSet addNews:@"TITLE 6"  :@"SUBTITLE 6"  :@"TEXT 6"  :@"image2" :@"2019-10-10T11:04:19Z": @"BBC"];
    [newSet addNews:@"TITLE 7"  :@"SUBTITLE 7"  :@"TEXT 7"  :@"image1" :@"2019-11-25T11:04:19Z": @"BBC"];
    [newSet addNews:@"TITLE 8"  :@"SUBTITLE 8"  :@"TEXT 8"  :@"image2" :@"2019-10-14T11:04:19Z": @"BBC"];
    [newSet addNews:@"TITLE 9"  :@"SUBTITLE 9"  :@"TEXT 9"  :@"image1" :@"2019-11-25T11:03:19Z": @"Hipertextual.com"];
    [newSet addNews:@"TITLE 10" :@"SUBTITLE 10" :@"TEXT 10" :@"image2" :@"2019-11-27T11:03:19Z": @"Mashable"];
    [newSet addNews:@"TITLE 11" :@"SUBTITLE 11" :@"TEXT 11" :@"image1" :@"2019-10-26T11:04:19Z": @"Chet.com"];
    [newSet addNews:@"TITLE 12" :@"SUBTITLE 12" :@"TEXT 12" :@"image2" :@"2019-11-13T11:04:19Z": @"Hipertextual.com"];
    
    self.isSort = NO;
    
    self.sortedNewsSet = [newSet sortByDatetime];
}

- (IBAction)findButton:(UIBarButtonItem *)sender {
    FindViewController * findView = [self.storyboard instantiateViewControllerWithIdentifier:@"findView"];
    
    findView.newsSet = newSet;
    
    [self.navigationController pushViewController:findView animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newSet getCount];
}

NSString * parseDatetime(NSString *datetime) {
    char month1 = [datetime characterAtIndex:5];
    char month2 = [datetime characterAtIndex:6];
    
    char day1 = [datetime characterAtIndex:8];
    char day2 = [datetime characterAtIndex:9];
    
    char hour1 = [datetime characterAtIndex:11];
    char hour2 = [datetime characterAtIndex:12];
    
    char minute1 = [datetime characterAtIndex:14];
    char minute2 = [datetime characterAtIndex:15];
    
    return [NSString stringWithFormat:@"%c%c.%c%c %c%c:%c%c", day1, day2, month1, month2, hour1, hour2, minute1, minute2];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NewsPost * post = [[NewsPost alloc] init];
    
    if (isSort) {
        post = [self.sortedNewsSet getAtIndex:indexPath.row];
    }
    else {
        post = [newSet getAtIndex:indexPath.row];
    }
    
    cell.imageView.image = [UIImage imageNamed:post.image];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = parseDatetime(post.datetime);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController * detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detaiView"];
    
    if (isSort) {
        detailView.newsPost = [self.sortedNewsSet getAtIndex:indexPath.row];
    }
    else {
        detailView.newsPost = [newSet getAtIndex:indexPath.row];
    }
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)switchActionSort:(UISwitch *)sender {
}

- (IBAction)switchActionSort:(UISwitch *)sender forEvent:(UIEvent *)event {
    if (self.isSort) {
        self.isSort = NO;
    }
    else {
        self.isSort = YES;
    }
    
    [self.table reloadData];
}

- (IBAction)filterActionButton:(UIButton *)sender {
    FilterViewController * filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"filterView"];
    
    filterView.newsSet = newSet;
    
    [self.navigationController pushViewController:filterView animated:YES];
}

- (IBAction)buttonSelectFilter:(UIButton *)sender {
    
}

@end
