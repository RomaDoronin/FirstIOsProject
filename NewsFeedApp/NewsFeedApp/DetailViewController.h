//
//  DetailViewController.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 11.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsSet.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *subtitleTextView;

@property (weak, nonatomic) IBOutlet UITextView *textUI;
@property (weak, nonatomic) IBOutlet UIImageView *imageUI;
@property (weak, nonatomic) IBOutlet UILabel *datetimeUI;
@property (weak, nonatomic) IBOutlet UILabel *sourceUI;

@property NewsPost * newsPost;

- (IBAction)sharePressed:(UIButton *)sender;

@end
