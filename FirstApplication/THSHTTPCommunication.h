//
//  THSHTTPCommunication.h
//  FirstApplication
//
//  Created by Roman Doronin on 10/2/19.
//  Copyright © 2019 Roman Doronin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THSHTTPCommunication : NSObject<NSURLSessionDownloadDelegate>

- (void)retrieveURL: (NSURL *)url successBlock:(void(^)(NSData *))successBlock;

@end
