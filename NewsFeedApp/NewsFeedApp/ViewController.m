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
#import "CollectionViewController.h"
#import "THSHTTPCommunication.h"
#import "ParseDatetime.h"
#import "ResizeImages.h"
#import "TableViewCell.h"
#import "LoadData.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
@private
    NewsSet * newsSet;
    BOOL isNewPageLoaded;
    BOOL isNeedToSort;
    BOOL isSort;
    NSMutableArray *newsSource;
    NewsSet * sortedNewsSet;
    NewsSet * tmpNewsSet;
    
    THSHTTPCommunication *http;
}

@end

static const int kPageSize = 20;
static const NSInteger kMaxNewsNum = 100;
static const NSInteger kPredNewsNumOfLoading = 5;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationViewController];
}

#pragma mark - Configuration
-(void)configurationViewController {
    http = [[THSHTTPCommunication alloc] init];
    
    isNewPageLoaded = NO;
    isNeedToSort = YES;
    isSort = NO;
    
    newsSet = [[NewsSet alloc] init];
    newsSource = [[NSMutableArray alloc] init];
    
    NSString *numFirstPage = @"1";
    [LoadData loadNewsFromURLFromView:self PageNum:numFirstPage PageSize:kPageSize Http:http NewsSet:newsSet NewsSource:newsSource];
}

#pragma mark - Get data from Server callback
- (void)didLoadNewsFromURLNewsSet {
    [self.table reloadData];
    isNewPageLoaded = NO;
}

- (void)didLoadImageFromURL {
    [self.table reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsSet getCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"customCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NewsPost * post = [[NewsPost alloc] init];
    
    post = [newsSet getAtIndex:indexPath.row];
    
    cell.NewsTitle.text = post.title;
    cell.NewsDatetime.text = [ParseDatetime parseDatetime:post.datetime];
    
    UIImage *image = [UIImage imageWithData:post.realImage];
    const NSInteger kImageSize = 80;    
    UIImage *resizeImage = [ResizeImages resizeImage:image KeepingProportionByOneSide:kImageSize];
    
    cell.NewsImage.image = resizeImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController * detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detaiView"];
    
    detailView.newsPost = [newsSet getAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSort) {
        return YES;
    }
    
    if ((indexPath.row == newsSet.getCount - kPredNewsNumOfLoading) && (!isNewPageLoaded)) {
        NSInteger page = newsSet.getCount / kPageSize + 1;
        if (page < kMaxNewsNum / kPageSize) {
            isNewPageLoaded = YES;
            isNeedToSort = YES;
            
            NSString *pageNum = [NSString stringWithFormat:@"%ld", (long)page];
            [LoadData loadNewsFromURLFromView:self PageNum:pageNum PageSize:kPageSize Http:http NewsSet:newsSet NewsSource:newsSource];
        }
    }
    
    return YES;
}

#pragma mark - Actions
- (IBAction)switchActionSort:(UISwitch *)sender {
}

- (IBAction)switchActionSort:(UISwitch *)sender forEvent:(UIEvent *)event {
    if (isNeedToSort) {
        isNeedToSort = NO;
        sortedNewsSet = [newsSet sortByDatetime];
    }
    
    if (isSort) {
        newsSet = tmpNewsSet;
        isSort = NO;
    }
    else {
        tmpNewsSet = newsSet;
        newsSet = sortedNewsSet;
        isSort = YES;
    }
    
    [self.table reloadData];
}

- (IBAction)findButton:(UIBarButtonItem *)sender {
    FindViewController * findView = [self.storyboard instantiateViewControllerWithIdentifier:@"findView"];
    
    findView.newsSet = newsSet;
    
    [self.navigationController pushViewController:findView animated:YES];
}

- (IBAction)filterActionButton:(UIButton *)sender {
    FilterViewController * filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"filterView"];
    
    filterView.newsSet = newsSet;
    filterView.newsSource = newsSource;
    
    [self.navigationController pushViewController:filterView animated:YES];
}

- (IBAction)buttonSelectFilter:(UIButton *)sender {
    
}

- (IBAction)gridActionButton:(UIBarButtonItem *)sender {
    CollectionViewController * gridView = [self.storyboard instantiateViewControllerWithIdentifier:@"gridView"];
    
    gridView.newsSet = newsSet;
    
    [self.navigationController pushViewController:gridView animated:YES];
}

@end
