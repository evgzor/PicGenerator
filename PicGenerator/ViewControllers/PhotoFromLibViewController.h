//
//  PhotoFromLibViewController.h
//  PicGenerator
//
//  Created by Zorin Evgeny on 25.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoFromLibViewController : UIViewController
/**
 *  send image to UIImageViewControl
 *
 *  @param image    result image
 *  @param metadata image metadata
 */
-(void)setUpImage:(UIImage*) image andMetaData :(NSDictionary *)metadata;

@end
