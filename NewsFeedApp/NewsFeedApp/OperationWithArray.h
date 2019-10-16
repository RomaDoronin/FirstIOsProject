//
//  OperationWithArray.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 16.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationWithArray : NSObject

+ (BOOL)checkForElementInArray:(NSMutableArray *)mArray :(id)elem;

@end
