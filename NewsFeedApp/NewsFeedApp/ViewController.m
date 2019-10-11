//
//  ViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 10.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    newSet = [[NewsSet alloc] init];
    [newSet print];
    [newSet addNews:@"TITLE 1"  :@"SUBTITLE 1"  :@"TEXT 1"  :@"image1"];
    [newSet addNews:@"TITLE 2"  :@"SUBTITLE 2"  :@"TEXT 2"  :@"image2"];
    [newSet addNews:@"TITLE 3"  :@"SUBTITLE 3"  :@"TEXT 3"  :@"image1"];
    [newSet addNews:@"TITLE 4"  :@"SUBTITLE 4"  :@"TEXT 4"  :@"image2"];
    [newSet addNews:@"TITLE 5"  :@"SUBTITLE 5"  :@"TEXT 5"  :@"image1"];
    [newSet addNews:@"TITLE 6"  :@"SUBTITLE 6"  :@"TEXT 6"  :@"image2"];
    [newSet addNews:@"TITLE 7"  :@"SUBTITLE 7"  :@"TEXT 7"  :@"image1"];
    [newSet addNews:@"TITLE 8"  :@"SUBTITLE 8"  :@"TEXT 8"  :@"image2"];
    [newSet addNews:@"TITLE 9"  :@"SUBTITLE 9"  :@"TEXT 9"  :@"image1"];
    [newSet addNews:@"TITLE 10" :@"SUBTITLE 10" :@"TEXT 10" :@"image2"];
    [newSet addNews:@"TITLE 11" :@"SUBTITLE 11" :@"TEXT 11" :@"image1"];
    [newSet addNews:@"TITLE 12" :@"SUBTITLE 12" :@"TEXT 12" :@"image2"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [newSet getCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.imageView.image = [UIImage imageNamed:[newSet getAtIndex:indexPath.row].image];
    cell.textLabel.text = [newSet getAtIndex:indexPath.row].title;
    cell.detailTextLabel.text = [newSet getAtIndex:indexPath.row].subtitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController * detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detaiView"];
    
    detailView.newsPost = [newSet getAtIndex:indexPath.row];
    
    //[self.navigationController pushViewController:detailView animated:YES];
}

@end
