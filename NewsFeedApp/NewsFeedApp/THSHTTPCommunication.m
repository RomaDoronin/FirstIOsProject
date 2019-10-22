//
//  THSHTTPCommunication.m
//  NewsFeedApp
//
//  Created by Roman Doronin on 15.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "THSHTTPCommunication.h"

@interface THSHTTPCommunication ()

@property (nonatomic, copy) void(^successBlock)(NSData *);

@end

@implementation THSHTTPCommunication {
@private
    NSURLSession *session;
}

- (id)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    }

    return self;
}

- (void)retrieveURL: (NSURL *)url successBlock:(void(^)(NSData *))successBlock {
    self.successBlock = successBlock;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    [task resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    //dispatch_async(_myDispatchQueue, ^{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.successBlock(data);
    });
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"dispatch_get_global_queue");
    });*/
    
    /*[_myQueue addOperationWithBlock:^{
        self.successBlock(data);
    }];*/
}

@end
