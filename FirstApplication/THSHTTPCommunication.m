//
//  THSHTTPCommunication.m
//  FirstApplication
//
//  Created by Roman Doronin on 10/2/19.
//  Copyright © 2019 Roman Doronin. All rights reserved.
//

#import "THSHTTPCommunication.h"

@interface THSHTTPCommunication ()

@property (nonatomic, copy) void(^successBlock)(NSData *);

@end

@implementation THSHTTPCommunication

- (void)retrieveURL:(NSURL *)url successBlock:(void(^)(NSData *))successBlock
{
    // Save successBlock for reqest it later
    self.successBlock = successBlock;
    
    // Create request using url
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // Create session using def conf and set our class example like delegat
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    // Prepare downloading
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    // Set HTTP connection
    [task resume];
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // Get downloaded data frol local storage
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        self.successBlock(data);
    });
}

@end
