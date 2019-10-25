//
//  NewsDistributor.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 25.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "NewsDistributor.h"
#import "THSHTTPCommunication.h"
#import "NewsSet.h"
#import <UIKit/UIKit.h>

@implementation NewsDistributor

static const NSInteger kPageSize = 20;

NSString* configurateURL(NSString *page) {
    NSString *apiKey = @"cef54047a9d94e41ad1ba8ffaa5d6bee";
    NSString *keyWord = @"Apple";
    NSString *date = @"2019-10-16";
    NSString *sortBy = @"popularity";
    
    return [NSString stringWithFormat:@"https://newsapi.org/v2/everything?q=%@&from=%@&sortBy=%@&apiKey=%@&pageSize=%d&page=%@",
            keyWord,
            date,
            sortBy,
            apiKey,
            kPageSize,
            page];
}

- (NSInteger)getPageSize {
    return kPageSize;
}

#pragma mark - Get data from Server
+ (void)getNewsFromURL:(NSString *)page ByHTTP:(THSHTTPCommunication *)http :(NewsSet *)newsSet :(NSMutableArray *)newsSource :(UITableView *)table {
    NSString *stringURL = configurateURL(page);
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
                    
                    [self getImageFromURL :imageURL :(newsSet.getCount - kPageSize)];
                }
                
                [self.table reloadData];
                isNewPageLoaded = NO;
            }
        }
    }];
}

+ (void)getImageFromURL:(NSString *)stringURL :(NSInteger)index {
    NSURL *url = [NSURL URLWithString:stringURL];
    
    __block NSInteger insideIndex = index;
    
    [http retrieveURL:url successBlock:^(NSData *response) {
        if (response) {
            [newsSet setRealImage:response :/*index*/insideIndex];
            
            [self.table reloadData];
            
            insideIndex++;
        }
        
        // So so
        /*if (index < newsSet.getCount - 1) {
         [self getImageFromURL :[newsSet getAtIndex:index + 1].image :index + 1];
         }*/
    }];
}

@end
