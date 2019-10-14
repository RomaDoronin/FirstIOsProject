//
//  ViewController.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 10.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsSet.h"

@interface ViewController : UIViewController {
@private
    NewsSet * newSet;
}

@property BOOL isSort;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ButtonFind;
@property (weak, nonatomic) IBOutlet UISwitch *switchSort;

- (IBAction)switchActionSort:(UISwitch *)sender forEvent:(UIEvent *)event;

@end

