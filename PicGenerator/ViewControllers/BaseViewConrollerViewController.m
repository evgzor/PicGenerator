//
//  BaseViewConrollerViewController.m
//  PicGenerator
//
//  Created by admin on 26.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "BaseViewConrollerViewController.h"

@interface BaseViewConrollerViewController ()

@end

@implementation BaseViewConrollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_generator addDelegate:self];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(startStopGenerator)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    _generator = nil;
}

#pragma mark - user action

-(void)startStopGenerator
{
    if (!_generator) {
        return;
    }
    NSString* titleText =  _generator.isStarted ? @"Start" : @"Pause";
    self.navigationItem.rightBarButtonItem.title =titleText;
    
    if (_generator.isStarted) {
        [_generator pause];
    }
    else
    {
        [_generator start];
    }
    
}

#pragma mark- NumberPicGeneratorDelegate realization

-(void)updateState
{
    NSString* titleText =  _generator.isStarted ? @"Pause" : @"Start";
    self.navigationItem.rightBarButtonItem.title = titleText;
}

@end
