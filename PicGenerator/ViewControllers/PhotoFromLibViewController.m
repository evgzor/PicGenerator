//
//  PhotoFromLibViewController.m
//  PicGenerator
//
//  Created by Zorin Evgeny on 25.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "PhotoFromLibViewController.h"
#import "PhotoCameraRoll.h"
#import "UtilsHelper.h"

@interface PhotoFromLibViewController ()
{
    UIImage* _image;
    NSDictionary* _metadata;
}

@property (nonatomic, weak) IBOutlet UIImageView* imageView;

@end

@implementation PhotoFromLibViewController

-(void)setUpImage:(UIImage*) image andMetaData :(NSDictionary *)metadata
{
    _image    = image;
    _metadata = metadata;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = _image;
    
    NSString* gpsDataString;
    
    BOOL isGPSDataValible = [CLLocation getLocationStringRepresentation:&gpsDataString forMetaData:_metadata];
    
    if (isGPSDataValible) {
        UIColor* textColor      = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
        UIColor* backgrounColor = [UIColor colorWithRed:1. green:0. blue:0. alpha:0.2];

        self.imageView.image    = [_image drawText:gpsDataString atPoint:CGPointMake(0, _image.size.height-70) withFontSize:16 andTextColor:textColor andBackgroundColor:backgrounColor];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - memory managment
-(void)dealloc
{
    _image    = nil;
    _metadata = nil;
}

@end
