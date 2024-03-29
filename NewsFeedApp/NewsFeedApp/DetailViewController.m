//
//  DetailViewController.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 11.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "DetailViewController.h"
#import "ParseDatetime.h"
#import "ResizeImages.h"

@interface DetailViewController ()

@end

const NSInteger kImageSize = 100;

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageWithData:self.newsPost.realImage];
    UIImage *resizeImage = [ResizeImages resizeImage:image KeepingProportionByOneSide:kImageSize];
    
    self.titleTextView.text = self.newsPost.title;
    self.subtitleTextView.text = self.newsPost.subtitle;
    if (self.newsPost.text == nil) {
        self.newsPost.text = @"";
    }
    self.textUI.text = self.newsPost.text;
    self.imageUI.image = resizeImage;
    self.datetimeUI.text = [ParseDatetime parseDatetime:self.newsPost.datetime];
    self.sourceUI.text = self.newsPost.source;
}

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
