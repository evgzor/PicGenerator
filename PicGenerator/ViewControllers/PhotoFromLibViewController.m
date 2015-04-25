//
//  PhotoFromLibViewController.m
//  PicGenerator
//
//  Created by Zorin Evgeny on 25.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "PhotoFromLibViewController.h"
#import "MHCameraRoll.h"
@import ImageIO;

@interface PhotoFromLibViewController ()
{
    UIImage* _image;
    NSDictionary* _metadata;
}

@property (nonatomic, weak) IBOutlet UIImageView* imageView;
//@property (nonatomic, weak) IBOutlet UILabel* metaDataLabel;

@end

@implementation PhotoFromLibViewController

-(void)setUpImage:(UIImage*) image andMetaData :(NSDictionary *)metadata
{
    _image = image;
    _metadata  = metadata;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = _image;
    
    NSString* gpsDataString;
    CLLocation* location;
    BOOL isGPSDataValible = [MHCameraRoll getLocation:&location andStringRepresentation:&gpsDataString forMetaData:_metadata];
    
    if (isGPSDataValible) {
        self.imageView.image = [self drawText:gpsDataString inImage:_image atPoint:CGPointMake(0, _image.size.height-70)];
       /* [MHCameraRoll location:location forCompletition:^(NSString *locateAt) {
            NSString* summaryDiscription = [NSString stringWithFormat:@"%@ %@",gpsDataString,locateAt];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                                self.imageView.image = [self drawText:summaryDiscription inImage:_image atPoint:CGPointMake(0, _image.size.height-70)];
                               
                           });
        }];*/
    }
    
    
    
}



-(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    
    NSMutableAttributedString *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",text]];
    
    // text color
    [textStyle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0. green:0. blue:0. alpha:0.5] range:NSMakeRange(0, textStyle.length)];
    
    // text font
    [textStyle addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(0, textStyle.length)];
    
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor greenColor];
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    
    // add text onto the image
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 255, 0, 0, 0.5f);
    CGContextFillRect(context, rect);
    
    [textStyle drawInRect:CGRectIntegral(rect)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
