//
//  ParseDatetime.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 16.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "ParseDatetime.h"

static const NSInteger kMonthPositionFirst = 5;
static const NSInteger kMonthPositionSecond = 6;

static const NSInteger kDayPositionFirst = 8;
static const NSInteger kDayPositionSecond = 9;

static const NSInteger kHourPositionFirst = 11;
static const NSInteger kHourPositionSecond = 12;

static const NSInteger kMinutePositionFirst = 14;
static const NSInteger kMinutePositionSecond = 15;

@implementation ParseDatetime

+ (NSString *)parseDatetime:(NSString *)datetime {
    if (datetime.length < 16) {
        NSException *myException = [NSException exceptionWithName:@"DatetimeMustBeAtLeast16" reason:@"The length of the datetime must be at least 16" userInfo:nil];
        @throw myException;
    }
    
    char month1 = [datetime characterAtIndex:kMonthPositionFirst];
    char month2 = [datetime characterAtIndex:kMonthPositionSecond];
    
    char day1 = [datetime characterAtIndex:kDayPositionFirst];
    char day2 = [datetime characterAtIndex:kDayPositionSecond];
    
    char hour1 = [datetime characterAtIndex:kHourPositionFirst];
    char hour2 = [datetime characterAtIndex:kHourPositionSecond];
    
    char minute1 = [datetime characterAtIndex:kMinutePositionFirst];
    char minute2 = [datetime characterAtIndex:kMinutePositionSecond];
    
    return [NSString stringWithFormat:@"%c%c.%c%c %c%c:%c%c", day1, day2, month1, month2, hour1, hour2, minute1, minute2];
}

@end
