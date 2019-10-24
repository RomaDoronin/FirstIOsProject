//
//  ParseDatetimeTests.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 24.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ParseDatetime.h"

@interface ParseDatetimeTests : XCTestCase

@end

@implementation ParseDatetimeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - (NSString *)parseDatetime:(NSString *)datetime
- (void)testParseDatetime {
    XCTAssertEqualObjects(@"09.08 18:31", [ParseDatetime parseDatetime:@"2005-08-09T18:31:42-03"]);
    XCTAssertEqualObjects(@"08.03 19:42", [ParseDatetime parseDatetime:@"2001-03-08T19:42:17-02"]);
    XCTAssertEqualObjects(@"19.11 08:05", [ParseDatetime parseDatetime:@"2010-11-19T08:05:12-01"]);
    XCTAssertEqualObjects(@"27.02 09:24", [ParseDatetime parseDatetime:@"2015-02-27T09:24:14+09"]);
    XCTAssertEqualObjects(@"30.09 19:41", [ParseDatetime parseDatetime:@"2015-09-30T19:41:59+12"]);
}

-(void)testEmplyInputString {
    void (^block)() = ^{
        [ParseDatetime parseDatetime:@""];
    };
    
    XCTAssertThrows(block());
}

-(void)testNilInputString {
    void (^block)() = ^{
        NSString *nilString;
        [ParseDatetime parseDatetime:nilString];
    };
    
    XCTAssertThrows(block());
}

-(void)testInvalidInput {
    void (^block)() = ^{
        [ParseDatetime parseDatetime:@"15-09-3"];
    };
    
    XCTAssertThrows(block());
}

@end
