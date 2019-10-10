//
//  NewsSet.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 10.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>

struct NewsPost {
    __unsafe_unretained NSString * title;
    __unsafe_unretained NSString * subtitle;
    __unsafe_unretained NSString * text;
    
    __unsafe_unretained NSString * image;
};

@interface NewsSet : NSObject{
    NSMutableArray * newsSet;
}

- (void) addNews : (NSString *) title : (NSString *) subtitle : (NSString *) text;

@end
