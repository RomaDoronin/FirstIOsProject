//
//  TableViewCell.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 22.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *NewsImage;
@property (weak, nonatomic) IBOutlet UILabel *NewsTitle;
@property (weak, nonatomic) IBOutlet UILabel *NewsDatetime;

@end
