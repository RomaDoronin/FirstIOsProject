//
//  NewsDistributor.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 25.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsSet;

@interface NewsDistributor : NSObject

- (NewsSet *)getNewsFromPage:(NSString *)page;

@end
