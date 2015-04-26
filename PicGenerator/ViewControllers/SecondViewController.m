//
//  SecondViewController.m
//  PicGenerator
//
//  Created by Zorin Evgeny on 24.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)evenUpdatedIdmage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.imageView.image = image;
                       
                   });
}

@end
