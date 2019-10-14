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
        post.title = @"";
        post.subtitle = @"";
        post.text = @"";
        post.image = @"";
        post.datetime = @"";
        newsPostArray = [NSMutableArray arrayWithObject:post];
        isFirstAdd = YES;
    }
    
    return self;
}

- (void) addNews : (NSString *) title : (NSString *) subtitle : (NSString *) text : (NSString *) image : (NSString *) datetime {
    if (isFirstAdd) {
        [newsPostArray removeObjectAtIndex:0];
        isFirstAdd = NO;
    }
    
    NewsPost * post = [[NewsPost alloc] init];
    post.title = title;
    post.subtitle = subtitle;
    post.text = text;
    post.image = image;
    post.datetime = datetime;
    [newsPostArray addObject:post];
}

- (long) getCount {
    return [newsPostArray count];
}

- (NewsPost *) getAtIndex : (long) index {
    return [newsPostArray objectAtIndex:index];
}

@end
