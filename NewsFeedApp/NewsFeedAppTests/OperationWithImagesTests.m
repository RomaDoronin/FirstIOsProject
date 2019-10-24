//
//  OperationWithImagesTests.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 24.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ResizeImages.h"

@interface OperationWithImagesTests : XCTestCase {
    UIImage *image;
}

@end

@implementation OperationWithImagesTests

- (void)setUp {
    [super setUp];
    image = [UIImage imageNamed:@"image1"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - (UIImage *)imagesWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
- (void)testResizeImage {
    NSInteger newWidth = image.size.width / 2;
    NSInteger newHeight = image.size.height / 3;
    UIImage *newImage = [ResizeImages imagesWithImage:image scaledToSize:CGSizeMake(newWidth, newHeight)];
    
    XCTAssertEqual(newWidth, newImage.size.width);
    XCTAssertEqual(newHeight, newImage.size.height);
}

- (void)testResizeAndResizeBack {
    NSInteger newWidth = image.size.width / 3;
    NSInteger newHeight = image.size.height * 2;
    UIImage *newImage = [ResizeImages imagesWithImage:image scaledToSize:CGSizeMake(newWidth, newHeight)];
    
    newWidth = newImage.size.width * 3;
    newHeight = newImage.size.height / 2;
    UIImage *backImage = [ResizeImages imagesWithImage:newImage scaledToSize:CGSizeMake(newWidth, newHeight)];
    
    XCTAssertEqualWithAccuracy(image.size.width, backImage.size.width, 2);
    XCTAssertEqual(image.size.width, backImage.size.height);
}

- (void)testZeroImage {
    UIImage *zeroImage = [ResizeImages imagesWithImage:image scaledToSize:CGSizeMake(0, 0)];
    UIImage *backImage = [ResizeImages imagesWithImage:zeroImage scaledToSize:CGSizeMake(image.size.width, image.size.height)];
    
    XCTAssertEqual(image.size.width, backImage.size.width);
    XCTAssertEqual(image.size.width, backImage.size.height);
}

-(void)testNilPointerImage {
    UIImage *emptyImage;
    NSInteger imageSize = 100;
    UIImage *newImage = [ResizeImages imagesWithImage:emptyImage scaledToSize:CGSizeMake(imageSize, imageSize)];
    
    XCTAssertEqual(imageSize, newImage.size.width);
    XCTAssertEqual(imageSize, newImage.size.height);
}

#pragma mark - (UIImage *)resizeImage:(UIImage *)image KeepingProportionByOneSide:(NSInteger)imageSize
- (void)testResizeImageKeepingProportion_1 {
    NSInteger val = 3;
    
    NSInteger newWidth = image.size.width / val;
    UIImage *newImage = [ResizeImages resizeImage:image KeepingProportionByOneSide:newWidth];
    
    NSInteger newHeight = image.size.height / val;
    
    XCTAssertEqual(newWidth, newImage.size.width);
    XCTAssertEqual(newHeight, newImage.size.height);
}

- (void)testResizeImageKeepingProportion_2 {
    NSInteger val = 3;
    
    NSInteger newWidth = image.size.width * val;
    UIImage *newImage = [ResizeImages resizeImage:image KeepingProportionByOneSide:newWidth];
    
    NSInteger newHeight = image.size.height * val;
    
    XCTAssertEqual(newWidth, newImage.size.width);
    XCTAssertEqual(newHeight, newImage.size.height);
}

- (void)testResizeImageKeepingProportion_3 {
    NSInteger val = 7;
    
    NSInteger newWidth = image.size.width / val;
    UIImage *newImage = [ResizeImages resizeImage:image KeepingProportionByOneSide:newWidth];
    
    NSInteger newHeight = image.size.height / val;
    
    XCTAssertEqualWithAccuracy(newWidth, newImage.size.width, val / 2);
    XCTAssertEqualWithAccuracy(newHeight, newImage.size.height, val / 2);
}


@end
