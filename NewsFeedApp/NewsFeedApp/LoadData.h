//
//  LoadData.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 30.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ViewController;
@class THSHTTPCommunication;
@class NewsSet;

@interface LoadData : NSObject

+ (void)loadNewsFromURLFromView:(ViewController *)view PageNum:(NSString *)pageNum PageSize:(NSInteger)pageSize Http:(THSHTTPCommunication *)http NewsSet:(NewsSet *)newsSet NewsSource:(NSMutableArray *)newsSource;
+ (void)loadImageFromURLFromView:(ViewController *)view StringURL:(NSString *)stringURL Index:(NSInteger)index Http:(THSHTTPCommunication *)http NewsSet:(NewsSet *)newsSet;
   
@end
