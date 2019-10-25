//
//  NewsSet.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 10.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "NewsSet.h"

@implementation NewsSet {
@private
    NSMutableArray * newsPostArray;
    bool isFirstAdd;
}

- (id) init {
    self = [super init];
    if (self) {
        isFirstAdd = YES;
    }
    
    return self;
}

- (void) addNews : (NSString *) title : (NSString *) subtitle : (NSString *) text : (NSString *) image : (NSString *) datetime : (NSString *) source {
    if (isFirstAdd) {
        newsPostArray = [[NSMutableArray alloc] init];
        isFirstAdd = NO;
    }
    
    NewsPost * post = [[NewsPost alloc] init];
    post.title = title;
    post.subtitle = subtitle;
    post.text = text;
    post.image = image;
    post.datetime = datetime;
    post.source = source;
    [newsPostArray addObject:post];
}

- (void) addNews : (NewsPost *) post {
    if (isFirstAdd) {
        newsPostArray = [[NSMutableArray alloc] init];
        isFirstAdd = NO;
    }
    
    [newsPostArray addObject:post];
}

- (long) getCount {
    return newsPostArray.count;
}

- (NewsPost *) getAtIndex : (long) index {
    return newsPostArray[index];
}

- (NewsSet *) sortByDatetime {
    NSArray *filtredNewsPostArray = [newsPostArray sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(NewsPost *obj1, NewsPost *obj2) {
        return [obj2.datetime localizedCaseInsensitiveCompare:obj1.datetime];
    }];
    
    NewsSet *filtredNewsSet = [[NewsSet alloc] init];
    for (NewsPost * post in filtredNewsPostArray) {
        [filtredNewsSet addNews:post];
    }
    
    return filtredNewsSet;
}

- (void) setRealImage : (NSData *) realImage : (long) index {
    NewsPost *post = [self getAtIndex:index];
    post.realImage = realImage;
}


- (NewsSet *)getCopy {
    NewsSet *copySet = [[NewsSet alloc] init];
    
    for(NewsPost *post in newsPostArray) {
        NewsPost *newPost = [[NewsPost alloc] init];
        
        newPost.title = post.title;
        newPost.subtitle = post.subtitle;
        newPost.text = post.text;
        newPost.image = post.image;
        newPost.realImage = post.realImage;
        newPost.datetime = post.datetime;
        newPost.source = post.source;
        
        [copySet addNews:newPost];
    }
    
    return copySet;
}

@end
