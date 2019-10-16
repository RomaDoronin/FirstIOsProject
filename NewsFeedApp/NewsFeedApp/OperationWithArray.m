//
//  OperationWithArray.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 16.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "OperationWithArray.h"

@implementation OperationWithArray

+ (BOOL)checkForElementInArray:(NSMutableArray *)mArray :(id)elem {
    for (NSString *elemCount in mArray) {
        if ([elemCount isEqualToString:elem]) {
            return YES;
        }
    }
    
    return NO;
}

@end
