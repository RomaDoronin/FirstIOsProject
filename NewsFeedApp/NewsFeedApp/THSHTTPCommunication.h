//
//  THSHTTPCommunication.h
//  NewsFeedApp
//
//  Created by Roman Doronin on 15.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THSHTTPCommunication : NSObject<NSURLSessionDownloadDelegate>

- (void)retrieveURL: (NSURL *)url successBlock:(void(^)(NSData *))successBlock;

@end
