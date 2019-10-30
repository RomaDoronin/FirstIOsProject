//
//  LoadData.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 30.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "LoadData.h"
#import "THSHTTPCommunication.h"
#import "NewsSet.h"
#import "ViewController.h"

@implementation LoadData

+ (void)loadNewsFromURLFromView:(ViewController *)view PageNum:(NSString *)pageNum PageSize:(NSInteger)pageSize Http:(THSHTTPCommunication *)http NewsSet:(NewsSet *)newsSet NewsSource:(NSMutableArray *)newsSource {
    NSString *apiKey = @"cef54047a9d94e41ad1ba8ffaa5d6bee";
    NSString *keyWord = @"Apple";
    NSString *date = @"2019-10-16";
    NSString *sortBy = @"popularity";
    
    NSString *stringURL = [NSString stringWithFormat:@"https://newsapi.org/v2/everything?q=%@&from=%@&sortBy=%@&apiKey=%@&pageSize=%d&page=%@",
                           keyWord,
                           date,
                           sortBy,
                           apiKey,
                           pageSize,
                           pageNum];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    [http retrieveURL:url successBlock:^(NSData *response) {
        NSError *error = nil;
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        
        if (!error) {
            if (data[@"articles"]) {
                NSArray *articles = data[@"articles"];
                for (NSDictionary *article in articles) {
                    NSDictionary *source = article[@"source"];
                    NSString *sourceName = source[@"name"];
                    NSString *imageURL = article[@"urlToImage"];
                    
                    [newsSet addNews:article[@"title"] :article[@"description"] :article[@"content"] :imageURL :article[@"publishedAt"] :sourceName];
                
                    if (![newsSource containsObject:sourceName]) {
                        [newsSource addObject:sourceName];
                    }
                    
                    [LoadData loadImageFromURLFromView:view StringURL:imageURL Index:(newsSet.getCount - pageSize) Http:http NewsSet:newsSet];
                }
                
                [view didLoadNewsFromURLNewsSet];
            }
        }
    }];
}

+ (void)loadImageFromURLFromView:(ViewController *)view StringURL:(NSString *)stringURL Index:(NSInteger)index Http:(THSHTTPCommunication *)http NewsSet:(NewsSet *)newsSet {
    NSURL *url = [NSURL URLWithString:stringURL];
    
    __block NSInteger insideIndex = index;
    
    [http retrieveURL:url successBlock:^(NSData *response) {
        if (response) {
            [newsSet setRealImage:response :insideIndex];
            
            insideIndex++;
            
            [view didLoadImageFromURL];
        }
    }];
}

@end
