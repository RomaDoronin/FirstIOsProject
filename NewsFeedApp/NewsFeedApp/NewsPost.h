//
//  NewsPost.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 11.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsPost : NSObject {
@private
    NSString * title;
    NSString * subtitle;
    NSString * text;
    
    NSString * image;
};

@property NSString * title;
@property NSString * subtitle;
@property NSString * text;

@property NSString * image;

@end
