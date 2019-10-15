//
//  CollectionViewController.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 15.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsSet.h"

@interface CollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property NewsSet *newsSet;

@end
