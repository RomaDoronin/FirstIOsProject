//
//  DetailViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 11.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleTextView.text = self.newsPost.title;
    self.subtitleTextView.text = self.newsPost.subtitle;
    self.textUI.text = self.newsPost.text;
    self.imageUI.image = [UIImage imageNamed:self.newsPost.image];
    self.datetimeUI.text = [ViewController parseDatetime:self.newsPost.datetime];
    self.sourceUI.text = self.newsPost.source;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
