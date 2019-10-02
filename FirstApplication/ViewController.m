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
    [self getCurrentTime];
}

- (void)getCurrentTime
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
                 
                 NSString *srtingTime = [time stringValue];
                 
                 const int ZERO_CHAR_CODE = 48;
                 const int POSITION_FOR_MS = 3;
                 const int TIMEZONE_MSK = 3;
                 const int MULTIPLIER = 10;
                 const int SEC_IN_MIN = 60;
                 const int MIN_IN_HOUR = 60;
                 const int HOUR_IN_DAY = 24;
                 
                 int intTimeSec = 0;
                 for (int i=0; i < [srtingTime length] - POSITION_FOR_MS; i++)
                 {
                     int currNum = (int)[srtingTime characterAtIndex:i] - ZERO_CHAR_CODE;
                     intTimeSec = intTimeSec * MULTIPLIER + currNum;
                 }
                 int intTimeMin = intTimeSec / SEC_IN_MIN;
                 int intTimeHour = intTimeMin / MIN_IN_HOUR;
                 
                 int sec = intTimeSec % SEC_IN_MIN;
                 int min = intTimeMin % MIN_IN_HOUR;
                 int hour = (intTimeHour + TIMEZONE_MSK) % HOUR_IN_DAY;
                 
                 [self.MyLable setText:[NSString stringWithFormat:@"%0.2d:%0.2d:%0.2d", hour, min, sec]];
             }
         }
     }];
}

@end
