//
//  NewsPost.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 11.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsPost : NSObject

@property NSString * title;
@property NSString * subtitle;
@property NSString * text;
@property NSString * image;
@property NSData * realImage;
@property NSString * datetime;
@property NSString * source;

@end
