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
    printf("retrieveURL start\n");
    
    // Save successBlock for reqest it later
    self.successBlock = successBlock;
    
    printf("retrieveURL 1\n");
    // Create request using url
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    printf("retrieveURL 3\n");
    // Create session using def conf and set our class example like delegat
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    printf("retrieveURL 3\n");
    // Prepare downloading
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    printf("retrieveURL 4\n");
    // Set HTTP connection
    [task resume];
    
    printf("retrieveURL End\n");
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    // Get downloaded data frol local DB
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        self.successBlock(data);
    });
}

@end
