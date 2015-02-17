//
//  IOViewController.m
//  IOToastInput
//
//  Created by Benjamin Prieur on 02/17/2015.
//  Copyright (c) 2014 Benjamin Prieur. All rights reserved.
//

#import "IOViewController.h"
#import <IOToastInput/IOToastInput.h>

@interface IOViewController ()

@end

@implementation IOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Toast";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:120/255.f green:160/255.f blue:190/255.f alpha:1.f]];
    [self.navigationController.navigationBar setOpaque:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [IOToastInputManager setDefaultOptions:@{kIOToastNotificationPresentationTypeKey: @(IOToastPresentationTypeUnder)}];
    
    [self popNewToast];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popNewToast)]];
}

- (void)popNewToast
{
    [IOToastInputManager showNotificationWithMessage:@"You can insert your doctor's email"
                                     completionBlock:^(NSInteger index, NSString *text) {
                                         NSLog(@"text insert : %@", text);
                                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
