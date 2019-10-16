//
//  ResizeImages.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 16.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ResizeImages : NSObject

+ (UIImage *)imagesWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
