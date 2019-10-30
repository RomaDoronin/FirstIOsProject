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
#import "Router.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
@private
    NewsSet *newsSet;
    NewsSet *sortedNewsSet;
    NewsSet *tmpNewsSet;
    NSMutableArray *newsSource;
    THSHTTPCommunication *http;
    BOOL isNewPageLoaded;
    BOOL isNeedToSort;
    BOOL isSort;
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
- (void)newsUploadingIndex:(NSInteger)index {
    if ((index == newsSet.getCount - kPredNewsNumOfLoading) && (!isNewPageLoaded)) {
        NSInteger page = newsSet.getCount / kPageSize + 1;
        if (page < kMaxNewsNum / kPageSize) {
            isNewPageLoaded = YES;
            isNeedToSort = YES;
            
            NSString *pageNum = [NSString stringWithFormat:@"%ld", (long)page];
            [LoadData loadNewsFromURLFromView:self PageNum:pageNum PageSize:kPageSize Http:http NewsSet:newsSet NewsSource:newsSource];
        }
    }
}

- (void)didLoadNewsFromURLNewsSet {
    [self.table reloadData];
    isNewPageLoaded = NO;
}

- (void)didLoadImageFromURL {
    [self.table reloadData];
}

#pragma mark - Setting object
- (void)settingTableCell:(TableViewCell *)cell Index:(NSInteger)index {
    NewsPost *post = [[NewsPost alloc] init];
    
    post = [newsSet getAtIndex:index];
    
    cell.NewsTitle.text = post.title;
    cell.NewsDatetime.text = [ParseDatetime parseDatetime:post.datetime];
    
    UIImage *image = [UIImage imageWithData:post.realImage];
    const NSInteger kImageSize = 80;
    UIImage *resizeImage = [ResizeImages resizeImage:image KeepingProportionByOneSide:kImageSize];
    
    cell.NewsImage.image = resizeImage;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newsSet getCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"customCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [self settingTableCell:cell Index:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [Router goToDetailView:self NewsSet:newsSet ViewId:@"detailView" Index:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSort) {
        return YES;
    }
    
    [self newsUploadingIndex:indexPath.row];
    
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
    [Router goToDetailView:self NewsSet:newsSet ViewId:@"findView"];
}

- (IBAction)filterActionButton:(UIButton *)sender {
    [Router goToDetailView:self NewsSet:newsSet ViewId:@"filterView" NewsSource:newsSource];
}

- (IBAction)buttonSelectFilter:(UIButton *)sender {
    
}

- (IBAction)gridActionButton:(UIBarButtonItem *)sender {
    [Router goToDetailView:self NewsSet:newsSet ViewId:@"gridView"];
}

@end
