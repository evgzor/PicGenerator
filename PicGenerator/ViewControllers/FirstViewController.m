//
//  FirstViewController.m
//  PicGenerator
//
//  Created by Zorin Evgeny on 24.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)unevenUpdatedImage:(UIImage *)image
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.imageView.image = image;
                       
                   });
    
}

@end
