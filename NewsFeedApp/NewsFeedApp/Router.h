//
//  Router.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 30.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsSet;
@class UIViewController;

@interface Router : NSObject

+ (void)goToDetailView:(UIViewController *)view NewsSet:(NewsSet *)newsSet ViewId:(NSString *)viewId;
+ (void)goToDetailView:(UIViewController *)view NewsSet:(NewsSet *)newsSet ViewId:(NSString *)viewId Index:(NSInteger)index;
+ (void)goToDetailView:(UIViewController *)view NewsSet:(NewsSet *)newsSet ViewId:(NSString *)viewId NewsSource:(NSMutableArray *)newsSource;
+ (void)goToDetailView:(UIViewController *)view NewsSet:(NewsSet *)newsSet ViewId:(NSString *)viewId Index:(NSInteger)index NewsSource:(NSMutableArray *)newsSource;

@end
