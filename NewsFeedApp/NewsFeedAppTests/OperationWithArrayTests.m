//
//  OperationWithArrayTests.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 24.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "OperationWithArray.h"

@interface OperationWithArrayTests : XCTestCase {
@private
    NSMutableArray *array;
}

@end

@implementation OperationWithArrayTests

- (void)setUp {
    [super setUp];
    array = [@[@"Liverpool", @"Arsenal", @"Chelsea"] copy];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testElemIsPresentInArray_first {
    XCTAssertTrue([OperationWithArray checkForElementInArray:array :@"Liverpool"]);
}

- (void)testElemIsPresentInArray_middle {
    XCTAssertTrue([OperationWithArray checkForElementInArray:array :@"Arsenal"]);
}

- (void)testElemIsPresentInArray_last {
    XCTAssertTrue([OperationWithArray checkForElementInArray:array :@"Chelsea"]);
}

- (void)testElemIsNotPresentInArray {
    XCTAssertFalse([OperationWithArray checkForElementInArray:array :@"Everton"]);
}

- (void)testEmptyArray {
    NSMutableArray *emptyArray = [@[] copy];
    XCTAssertFalse([OperationWithArray checkForElementInArray:emptyArray :@"Liverpool"]);
}

- (void)testInvalidElem {
    NSDictionary *dict;
    XCTAssertFalse([OperationWithArray checkForElementInArray:array :dict]);
}

-(void)testNilPointerArray {
    NSMutableArray *emptyArray;
    XCTAssertFalse([OperationWithArray checkForElementInArray:emptyArray :@"Liverpool"]);
}

@end
