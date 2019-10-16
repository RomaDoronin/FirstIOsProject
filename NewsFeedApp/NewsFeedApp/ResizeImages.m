//
//  ResizeImages.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 16.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "ResizeImages.h"

@implementation ResizeImages

+ (UIImage *)imagesWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
