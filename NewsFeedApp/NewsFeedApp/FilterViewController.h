//
//  FilterViewController.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 14.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsSet.h"

@interface FilterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property NewsSet *newsSet;
@property NSArray *newsSource;

@property (weak, nonatomic) IBOutlet UITableView *filterTable;
@property (weak, nonatomic) IBOutlet UIPickerView *filterPickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;

- (IBAction)filterActionButton:(UIBarButtonItem *)sender;

@end
