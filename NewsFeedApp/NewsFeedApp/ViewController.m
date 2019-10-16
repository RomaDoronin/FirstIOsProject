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

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
@private
    NSMutableArray *newsSource;
    BOOL isNewPageLoaded;
}

@property NewsSet * sortedNewsSet;
@property BOOL isHardcode;
@property BOOL isNeedToSort;

@end

@implementation ViewController

@synthesize isSort;
@synthesize isHardcode;
@synthesize isNeedToSort;

- (void)viewDidLoad {
    [super viewDidLoad];
    isHardcode = NO;
    isNeedToSort = YES;
    isNewPageLoaded = NO;
    
    newSet = [[NewsSet alloc] init];
    
    [self getNewsFromServer: @"1"];
    
    self.isSort = NO;
}

- (void)getNewsFromServer:(NSString *)page {
    THSHTTPCommunication *http = [[THSHTTPCommunication alloc] init];
    NSString *apiKey = @"cef54047a9d94e41ad1ba8ffaa5d6bee";
    NSString *keyWord = @"Apple";
    NSString *date = @"2019-10-15";
    NSString *sortBy = @"popularity";
    NSString *pageSize = @"20";
    NSString *stringURL = [NSString stringWithFormat:@"https://newsapi.org/v2/everything?q=%@&from=%@&sortBy=%@&apiKey=%@&pageSize=%@&page=%@", keyWord, date, sortBy, apiKey, pageSize, page];
    NSURL *url = [NSURL URLWithString:stringURL];
    
    [http retrieveURL:url successBlock:^(NSData *response) {
        NSError *error = nil;
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        
        if (!error) {
            if (data[@"articles"]) {
                NSArray *articles = data[@"articles"];
                newsSource = [[NSMutableArray alloc] init];
                for (NSDictionary *article in articles) {
                    NSDictionary *source = [article objectForKey:@"source"];
                    NSString *sourceName = [source objectForKey:@"name"];
                    NSString *imageURL = [article objectForKey:@"urlToImage"];
                    
                    [newSet addNews:[article objectForKey:@"title"] :[article objectForKey:@"description"] :[article objectForKey:@"content"] :imageURL :[article objectForKey:@"publishedAt"] :sourceName];
                    
                    BOOL isDuplicate = NO;
                    for (NSString *sourceCount in newsSource) {
                        if ([sourceCount isEqualToString:sourceName]) {
                            isDuplicate = YES;
                        }
                    }
                    if (!isDuplicate) {
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

- (IBAction)findButton:(UIBarButtonItem *)sender {
    FindViewController * findView = [self.storyboard instantiateViewControllerWithIdentifier:@"findView"];
    
    findView.newsSet = newSet;
    
    [self.navigationController pushViewController:findView animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newSet getCount];
}

+ (NSString *)parseDatetime:(NSString *)datetime {
    if (datetime.length == 0) {
        return @"";
    }
    
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

+ (UIImage *)imagesWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    
    cell.imageView.image = [ViewController imagesWithImage:[UIImage imageWithData:post.realImage] scaledToSize:CGSizeMake(70, 70)];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = [ViewController parseDatetime:post.datetime];
    
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
    if (isNeedToSort) {
        isNeedToSort = NO;
        self.sortedNewsSet = [newSet sortByDatetime];
    }
    
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


// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == newSet.getCount - 5) && (!isNewPageLoaded)) {
        isNewPageLoaded = YES;
        NSInteger page = newSet.getCount / 20 + 1;
        [self getNewsFromServer: [NSString stringWithFormat:@"%d", page]];
    }
    
    return YES;
}

@end
