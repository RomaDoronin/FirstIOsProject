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
#import "OperationWithArray.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
@private
    BOOL isNewPageLoaded;
    BOOL isNeedToSort;
    BOOL isSort;
    NSInteger pageSize;
    NSMutableArray *newsSource;
    NewsSet * sortedNewsSet;
    NewsSet * tmpNewsSet;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationViewController];
}

#pragma mark - Configuration
-(void)configurationViewController {
    isNewPageLoaded = NO;
    isNeedToSort = YES;
    isSort = NO;
    pageSize = 20;
    
    newSet = [[NewsSet alloc] init];
    newsSource = [[NSMutableArray alloc] init];
    
    NSString *numFirstPage = @"1";
    
    [self getNewsFromURL: numFirstPage];
}

#pragma mark - Get data from Server
- (void)getNewsFromURL:(NSString *)page {
    THSHTTPCommunication *http = [[THSHTTPCommunication alloc] init];
    
    NSString *apiKey = @"cef54047a9d94e41ad1ba8ffaa5d6bee";
    NSString *keyWord = @"Apple";
    NSString *date = @"2019-10-15";
    NSString *sortBy = @"popularity";
    
    NSString *stringURL = [NSString stringWithFormat:@"https://newsapi.org/v2/everything?q=%@&from=%@&sortBy=%@&apiKey=%@&pageSize=%d&page=%@",
                           keyWord,
                           date,
                           sortBy,
                           apiKey,
                           pageSize,
                           page];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    [http retrieveURL:url successBlock:^(NSData *response) {
        NSError *error = nil;
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        
        if (!error) {
            if (data[@"articles"]) {
                NSArray *articles = data[@"articles"];
                for (NSDictionary *article in articles) {
                    NSDictionary *source = [article objectForKey:@"source"];
                    NSString *sourceName = [source objectForKey:@"name"];
                    NSString *imageURL = [article objectForKey:@"urlToImage"];
                    
                    [newSet addNews:[article objectForKey:@"title"] :[article objectForKey:@"description"] :[article objectForKey:@"content"] :imageURL :[article objectForKey:@"publishedAt"] :sourceName];
                    
                    
                    if (![OperationWithArray checkForElementInArray :newsSource :sourceName]) {
                        [newsSource addObject:sourceName];
                    }
                    
                    [self getImageFromURL :imageURL :(newSet.getCount - 1)];
                }
                
                [self.table reloadData];
                isNewPageLoaded = NO;
            }
        }
    }];
}

- (void)getImageFromURL:(NSString *)stringURL :(NSInteger)index {
    THSHTTPCommunication *http = [[THSHTTPCommunication alloc] init];
    NSURL *url = [NSURL URLWithString:stringURL];
    
    [http retrieveURL:url successBlock:^(NSData *response) {
        if (response) {
            [newSet setRealImage:response :index];
            
            [self.table reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newSet getCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NewsPost * post = [[NewsPost alloc] init];
    
    post = [newSet getAtIndex:indexPath.row];
    
    cell.imageView.image = [ResizeImages imagesWithImage:[UIImage imageWithData:post.realImage] scaledToSize:CGSizeMake(70, 70)];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = [ParseDatetime parseDatetime:post.datetime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController * detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detaiView"];
    
    detailView.newsPost = [newSet getAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger PRED_NEWS_NUM_OF_LOADING = 5;
    
    if ((indexPath.row == newSet.getCount - PRED_NEWS_NUM_OF_LOADING) && (!isNewPageLoaded)) {
        if (!isSort) {
            isNewPageLoaded = YES;
            NSInteger page = newSet.getCount / pageSize + 1;
            [self getNewsFromURL: [NSString stringWithFormat:@"%d", page]];
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
        sortedNewsSet = [newSet sortByDatetime];
    }
    
    if (isSort) {
        newSet = tmpNewsSet;
        isSort = NO;
    }
    else {
        tmpNewsSet = newSet;
        newSet = sortedNewsSet;
        isSort = YES;
    }
    
    [self.table reloadData];
}

- (IBAction)findButton:(UIBarButtonItem *)sender {
    FindViewController * findView = [self.storyboard instantiateViewControllerWithIdentifier:@"findView"];
    
    findView.newsSet = newSet;
    
    [self.navigationController pushViewController:findView animated:YES];
}

- (IBAction)filterActionButton:(UIButton *)sender {
    FilterViewController * filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"filterView"];
    
    filterView.newsSet = newSet;
    filterView.newsSource = newsSource;
    
    [self.navigationController pushViewController:filterView animated:YES];
}

- (IBAction)buttonSelectFilter:(UIButton *)sender {
    
}

- (IBAction)gridActionButton:(UIBarButtonItem *)sender {
    CollectionViewController * gridView = [self.storyboard instantiateViewControllerWithIdentifier:@"gridView"];
    
    gridView.newsSet = newSet;
    
    [self.navigationController pushViewController:gridView animated:YES];
}

@end
