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
#import "NewsDistributor.h"
#import "ParseDatetime.h"
#import "ResizeImages.h"
#import "TableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
@private
    NewsSet * newsSet;
    BOOL isNewPageLoaded;
    BOOL isNeedToSort;
    BOOL isSort;
    NSMutableArray *newsSource;
    NewsSet * sortedNewsSet;
    NewsSet * tmpNewsSet;
    NewsDistributor *newsDistributor;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ButtonFind;
@property (weak, nonatomic) IBOutlet UISwitch *switchSort;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

- (IBAction)switchActionSort:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)filterActionButton:(UIButton *)sender;

@end

static const NSInteger kMaxNewsNum = 100;
static const NSInteger kPredNewsNumOfLoading = 5;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationViewController];
    _table.rowHeight = UITableViewAutomaticDimension;
    _table.estimatedRowHeight = 200;
}

#pragma mark - Configuration
-(void)configurationViewController {
    newsDistributor = [[NewsDistributor alloc] init];
    
    isNewPageLoaded = NO;
    isNeedToSort = YES;
    isSort = NO;
    
    newsSet = [[NewsSet alloc] init];
    newsSource = [[NSMutableArray alloc] init];
    
    NSString *numFirstPage = @"1";
    newsSet = [newsDistributor getNewsFromPage:numFirstPage];
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
    //const NSInteger kImageSize = 10;
    //UIImage *resizeImage = [ResizeImages resizeImage:image KeepingProportionByOneSide:kImageSize];
    
    cell.NewsImage.image = image;

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
            [self getNewsFromURL: [NSString stringWithFormat:@"%ld", (long)page]];
        }
    }
    
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

/*- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10;
}*/

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
