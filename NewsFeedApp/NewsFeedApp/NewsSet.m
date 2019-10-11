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
    self = [super init];
    if (self) {
        NewsPost * post = [[NewsPost alloc] init];
        post.title = @"First title";
        post.subtitle = @"First subtitle";
        post.text = @"First text";
        post.image = @"image1";
        newsPostArray = [NSMutableArray arrayWithObject:post];
        isFirstAdd = YES;
    }
    
    return self;
}

- (void) addNews : (NSString *) title : (NSString *) subtitle : (NSString *) text : (NSString *) image  {
    if (isFirstAdd) {
        [newsPostArray removeObjectAtIndex:0];
        isFirstAdd = NO;
    }
    
    NewsPost * post = [[NewsPost alloc] init];
    post.title = title;
    post.subtitle = subtitle;
    post.text = text;
    post.image = image;
    [newsPostArray addObject:post];
}

- (long) getCount {
    return [newsPostArray count];
}

- (void) print {
    for (NewsPost * post in newsPostArray) {
        NSLog(@"\nTitle: %@\nSubtitle: %@\nText: %@"
             ,post.title
             ,post.subtitle
             ,post.text
             );
    }
}

- (NewsPost *) getAtIndex : (long) index {
    return [newsPostArray objectAtIndex:index];
}

@end
