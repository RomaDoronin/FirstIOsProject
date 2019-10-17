//
//  FindViewController.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 14.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsSet;

@interface FindViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *findTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property NewsSet *newsSet;

@end
