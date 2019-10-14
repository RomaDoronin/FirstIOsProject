//
//  ViewController.m
//  AgainAndAgain
//
//  Created by Roman Doronin on 14.10.19.
//  Copyright (c) 2019 Roman Doronin. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerOtherWindow.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)ButtonNEXT:(UIButton *)sender {
    NSLog(@"PUSH NEXT");
    ViewControllerOtherWindow * viewControllerOthWin = [self.storyboard instantiateViewControllerWithIdentifier:@"otherWindow"];
    
    viewControllerOthWin.someText = self.inputText.text;
    
    [self.navigationController pushViewController:viewControllerOthWin animated:YES];
}

@end
