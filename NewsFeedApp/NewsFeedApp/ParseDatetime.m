//
//  ParseDatetime.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 16.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "ParseDatetime.h"

@implementation ParseDatetime

+ (NSString *)parseDatetime:(NSString *)datetime {
    if (datetime.length == 0) {
        return @"";
    }
    
    char month1 = [datetime characterAtIndex:5];
    char month2 = [datetime characterAtIndex:6];
    
    char day1 = [datetime characterAtIndex:8];
    char day2 = [datetime characterAtIndex:9];
    
    char hour1 = [datetime characterAtIndex:11];
    char hour2 = [datetime characterAtIndex:12];
    
    char minute1 = [datetime characterAtIndex:14];
    char minute2 = [datetime characterAtIndex:15];
    
    return [NSString stringWithFormat:@"%c%c.%c%c %c%c:%c%c", day1, day2, month1, month2, hour1, hour2, minute1, minute2];
}

@end
