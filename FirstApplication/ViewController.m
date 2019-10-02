//
//  ViewController.m
//  FirstApplication
//
//  Created by Roman Doronin on 10/1/19.
//  Copyright © 2019 Roman Doronin. All rights reserved.
//

#import "ViewController.h"
#import "THSHTTPCommunication.h"

@interface ViewController ()
{
    NSNumber *localTime;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)myAction:(UIButton *)sender {
    [self retrieveRandomJokes];
}

- (void) PrintInLable:(NSString*)str {
    self.MyLable.text = str;
}

- (void)retrieveRandomJokes
{
    THSHTTPCommunication *http = [[THSHTTPCommunication alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://yandex.ru/time/sync.json?geo=47%2c213%2C202%2C10393%2C10636&lang=ru&ncrnd=0.13321626382539664"];
    
    [http retrieveURL:url successBlock:^(NSData *response)
     {
         NSError *error = nil;
        
         NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
         
         if (!error)
         {
             if (data[@"time"])
             {
                 NSNumber *time = data[@"time"];
                 NSLog(@"time: %@", time);
                 NSLog(@"Type time: %@", [time class]);
                 
                 NSString *time1 = [time stringValue];
                 NSLog(@"Type time1: %@", [time1 class]);
                 int sum = 0;
                 for (int i=0; i < [time1 length] - 3; i++)
                 {
                     int add = (int)[time1 characterAtIndex:i] - 48;
                     sum = sum * 10 + add;
                 }
                 int TimezoneNN = 3;
                 int sec = sum % 60;
                 int min = (sum / 60) % 60;
                 int hour = (((sum / 60)) / 60 + TimezoneNN) % 24;
                 
                 printf("%0.2d:%0.2d:%0.2d", hour, min, sec);
                 [self.MyLable setText:[NSString stringWithFormat:@"%0.2d:%0.2d:%0.2d", hour, min, sec]];
             }
         }
     }];
}

@end
