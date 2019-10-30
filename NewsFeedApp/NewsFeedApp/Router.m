//
//  Router.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 30.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "Router.h"
#import "DetailViewController.h"
#import "FindViewController.h"
#import "FilterViewController.h"
#import "CollectionViewController.h"
#import <UIKit/UIKit.h>

@implementation Router

+ (void)goToDetailView:(UIViewController *)view NewsSet:(NewsSet *)newsSet ViewId:(NSString *)viewId {
    [Router goToDetailView:view NewsSet:newsSet ViewId:viewId Index:0 NewsSource:nil];
}

+ (void)goToDetailView:(UIViewController *)view NewsSet:(NewsSet *)newsSet ViewId:(NSString *)viewId Index:(NSInteger)index {
    [Router goToDetailView:view NewsSet:newsSet ViewId:viewId Index:index NewsSource:nil];
}

+ (void)goToDetailView:(UIViewController *)view NewsSet:(NewsSet *)newsSet ViewId:(NSString *)viewId NewsSource:(NSMutableArray *)newsSource {
    [Router goToDetailView:view NewsSet:newsSet ViewId:viewId Index:0 NewsSource:newsSource];
}

+ (void)goToDetailView:(UIViewController *)view NewsSet:(NewsSet *)newsSet ViewId:(NSString *)viewId Index:(NSInteger)index NewsSource:(NSMutableArray *)newsSource {
    if ([viewId isEqualToString:@"detailView"]) {
        DetailViewController *detailView = [view.storyboard instantiateViewControllerWithIdentifier:viewId];
        detailView.newsPost = [newsSet getAtIndex:index];
        [view.navigationController pushViewController:detailView animated:YES];
    }
    else if ([viewId isEqualToString:@"findView"]) {
        FindViewController *findView = [view.storyboard instantiateViewControllerWithIdentifier:viewId];
        findView.newsSet = newsSet;
        [view.navigationController pushViewController:findView animated:YES];
    }
    else if ([viewId isEqualToString:@"filterView"]) {
        FilterViewController *filterView = [view.storyboard instantiateViewControllerWithIdentifier:viewId];
        filterView.newsSet = newsSet;
        filterView.newsSource = newsSource;
        [view.navigationController pushViewController:filterView animated:YES];
    }
    else if ([viewId isEqualToString:@"gridView"]) {
        CollectionViewController *gridView = [view.storyboard instantiateViewControllerWithIdentifier:viewId];
        gridView.newsSet = newsSet;
        [view.navigationController pushViewController:gridView animated:YES];
    }
}

@end
