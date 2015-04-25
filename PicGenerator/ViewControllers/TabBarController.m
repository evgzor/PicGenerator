//
//  TabBarController.m
//  PicGenerator
//
//  Created by Zorin Evgeny on 25.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "TabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    FirstViewController* firstVC = [storyboard instantiateViewControllerWithIdentifier:@"first"];
    SecondViewController* secondVC = [storyboard instantiateViewControllerWithIdentifier:@"second"];
    
    UINavigationController *thirdVC = [storyboard instantiateViewControllerWithIdentifier:@"third"];
    
    self.viewControllers = [NSArray arrayWithObjects:firstVC, secondVC,thirdVC,nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
