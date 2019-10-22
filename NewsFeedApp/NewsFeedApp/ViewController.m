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
    
    THSHTTPCommunication *http;
}

@end

static const NSInteger kPageSize = 20;
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
    [self getNewsFromURL: numFirstPage];
}

#pragma mark - Get data from Server
- (void)getNewsFromURL:(NSString *)page {
    //THSHTTPCommunication *http = [[THSHTTPCommunication alloc] init];
    
    NSString *apiKey = @"cef54047a9d94e41ad1ba8ffaa5d6bee";
    NSString *keyWord = @"Apple";
    NSString *date = @"2019-10-16";
    NSString *sortBy = @"popularity";
    
    NSString *stringURL = [NSString stringWithFormat:@"https://newsapi.org/v2/everything?q=%@&from=%@&sortBy=%@&apiKey=%@&pageSize=%d&page=%@",
                           keyWord,
                           date,
                           sortBy,
                           apiKey,
                           kPageSize,
                           page];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    [http retrieveURL:url successBlock:^(NSData *response) {
        NSError *error = nil;
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        
        if (!error) {
            if (data[@"articles"]) {
                NSArray *articles = data[@"articles"];
                for (NSDictionary *article in articles) {
                    NSDictionary *source = article[@"source"];
                    NSString *sourceName = source[@"name"];
                    NSString *imageURL = article[@"urlToImage"];
                    
                    [newsSet addNews:article[@"title"] :article[@"description"] :article[@"content"] :imageURL :article[@"publishedAt"] :sourceName];
                    
                    
                    if (![OperationWithArray checkForElementInArray :newsSource :sourceName]) {
                        [newsSource addObject:sourceName];
                    }
                    
                    [self getImageFromURL :imageURL :(newsSet.getCount - kPageSize)];
                }
                // So so
                /*[self getImageFromURL :articles[0][@"urlToImage"] :0];*/
                
                [self.table reloadData];
                isNewPageLoaded = NO;
            }
        }
    }];
}

- (void)getImageFromURL:(NSString *)stringURL :(NSInteger)index {
    //THSHTTPCommunication *http = [[THSHTTPCommunication alloc] init];
    NSURL *url = [NSURL URLWithString:stringURL];
    
    __block int insideIndex = index;
    
    [http retrieveURL:url successBlock:^(NSData *response) {
        if (response) {
            [newsSet setRealImage:response :/*index*/insideIndex];
            
            [self.table reloadData];
            
            insideIndex++;
        }
        
        // So so
        /*if (index < newsSet.getCount - 1) {
            [self getImageFromURL :[newsSet getAtIndex:index + 1].image :index + 1];
        }*/
    }];
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
    
    NSInteger height = image.size.height;
    NSInteger width = image.size.width;
    NSInteger result;
    
    const NSInteger kImageSize = 80;
    
    if (height != 0) {
        result = width * kImageSize / height;
    }
    else
    {
        result = 0;
    }
    NSLog(@"Result: %d", result);
    UIImage *resizeImage = [ResizeImages imagesWithImage:image scaledToSize:CGSizeMake(result, kImageSize)];
    
    cell.NewsImage.image = resizeImage;
    
    //cell.imageView.image = [UIImage imageWithData:post.realImage];[ResizeImages imagesWithImage:[UIImage imageWithData:post.realImage] scaledToSize:CGSizeMake(70, 70)];
    //cell.textLabel.text = post.title;
    //cell.detailTextLabel.text = [ParseDatetime parseDatetime:post.datetime];
    
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
