//
//  NewsSet.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 10.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsPost.h"

@interface NewsSet : NSObject{
    NSMutableArray * newsPostArray;
    bool isFirstAdd;
}

- (void) addNews : (NSString *) title : (NSString *) subtitle : (NSString *) text : (NSString *) image;
- (long) getCount;
- (NewsPost *) getAtIndex : (long) index;

- (void) print;

@end
