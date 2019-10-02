//
//  ViewController.h
//  FirstApplication
//
//  Created by Roman Doronin on 10/1/19.
//  Copyright © 2019 Roman Doronin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *MyButton;
@property (weak, nonatomic) IBOutlet UILabel *MyLable;

- (IBAction)myAction:(UIButton *)sender;

@end