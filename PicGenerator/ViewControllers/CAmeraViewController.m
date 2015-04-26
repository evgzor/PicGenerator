//
//  CAmeraViewController.m
//  PicGenerator
//
//  Created by Zorin Evgeny on 24.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "CAmeraViewController.h"
#import <ImageIO/ImageIO.h>
@import AVKit;
@import AVFoundation;
#import "PhotoCameraRoll.h"
#import "UtilsHelper.h"


@interface CAmeraViewController () <CLLocationManagerDelegate>
    
@property (nonatomic, strong) CLLocationManager *locationManager;

@property(nonatomic, weak) IBOutlet UIView *vImagePreview;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@end

@implementation CAmeraViewController

#pragma mark - viewLifeCicle

-(void)viewDidLoad
{
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
    
    [_locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    [_stillImageOutput setOutputSettings:outputSettings];
    

    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;;
    
    CALayer *viewLayer = self.vImagePreview.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    [self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
        
        [[[UIAlertView alloc] initWithTitle:@"Camera Error" message:[NSString stringWithFormat:@"ERROR: trying to open camera: %@", error] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [session addInput:input];
    [session addOutput:_stillImageOutput];
    [session startRunning];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    _locationManager.delegate = nil;
    _locationManager = nil;
    _stillImageOutput = nil;
}

#pragma mark - user action
-(IBAction) captureNow
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    NSLog(@"about to request a capture from: %@", _stillImageOutput);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         
         [PhotoCameraRoll saveImage:image withInfo:(__bridge NSDictionary*)exifAttachments forLocation:_locationManager.location];
         
     }];
}




@end
