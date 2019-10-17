//
//  ViewController.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 10.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsSet;

@interface ViewController : UIViewController {
@private
    NewsSet * newSet;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ButtonFind;
@property (weak, nonatomic) IBOutlet UISwitch *switchSort;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

- (IBAction)switchActionSort:(UISwitch *)sender forEvent:(UIEvent *)event;
- (IBAction)filterActionButton:(UIButton *)sender;

@end

