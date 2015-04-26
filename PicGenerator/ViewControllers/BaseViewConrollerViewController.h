//
//  BaseViewConrollerViewController.h
//  PicGenerator
//
//  Created by admin on 26.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberPicGenerator.h"

@interface BaseViewConrollerViewController : UIViewController <NumberPicGeneratorDelegate>

@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic,strong) NumberPicGenerator* generator;

@end
