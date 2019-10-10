//
//  NewsSet.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 10.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "NewsSet.h"

@implementation NewsSet

- (id) init {
    self = [self init];
    if (self) {
        newsSet = [NSMutableArray array];
    }
    
    return 0;
}

- (void) addNews : (NSString *) title : (NSString *) subtitle : (NSString *) text {
    struct NewsPost news;
    news.title = title;
    news.subtitle = subtitle;
    news.text = text;
    news.image = @"Some image";
    //[newsSet addObject:news];
}

@end
