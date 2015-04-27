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
#include "NumberPicGenerator.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NumberPicGenerator* generator     = [[NumberPicGenerator alloc] init];

    UIStoryboard *storyboard          = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    FirstViewController* firstVC      = [storyboard instantiateViewControllerWithIdentifier:@"first"];
    firstVC.generator                 = generator;

    UINavigationController* firstNav  = [[UINavigationController alloc] initWithRootViewController:firstVC];

    SecondViewController* secondVC    = [storyboard instantiateViewControllerWithIdentifier:@"second"];
    secondVC.generator                = generator;

    UINavigationController* secondNav = [[UINavigationController alloc] initWithRootViewController:secondVC];

    ThirdViewController *thirdVC      = [storyboard instantiateViewControllerWithIdentifier:@"third"];

    UINavigationController* thirdNav  = [[UINavigationController alloc] initWithRootViewController:thirdVC];

    self.viewControllers              = @[firstNav, secondNav,thirdNav];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         self.selectedIndex = idx;
    }];
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
