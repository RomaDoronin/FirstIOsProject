//
//  FindTableViewCell.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 24.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lableFindTitle;
@property (weak, nonatomic) IBOutlet UILabel *lableFindDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imageFind;

@end
