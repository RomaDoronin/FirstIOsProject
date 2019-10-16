//
//  DetailViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 11.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "DetailViewController.h"
#import "ParseDatetime.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleTextView.text = self.newsPost.title;
    self.subtitleTextView.text = self.newsPost.subtitle;
    if (self.newsPost.text) {
        self.textUI.text = self.newsPost.text;
    }
    else {
        self.textUI.text = @"";
    }
    self.imageUI.image = [UIImage imageWithData:self.newsPost.realImage];
    self.datetimeUI.text = [ParseDatetime parseDatetime:self.newsPost.datetime];
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

- (IBAction)sharePressed:(UIButton *)sender {
    NSArray *sharedData = @[self.titleTextView.text,
                            self.subtitleTextView.text,
                            self.textUI.text,
                            self.imageUI.image,
                            self.datetimeUI.text,
                            self.sourceUI.text
                            ];
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems: sharedData applicationActivities:nil];
    activityView.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityView animated:YES completion:nil];
}

@end
