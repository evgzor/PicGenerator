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
/**
 *  Picture representation control
 */
@property (nonatomic, weak  ) IBOutlet UIImageView        * imageView;
/**
 *  pointer to generator picture object
 */
@property (nonatomic, strong) NumberPicGenerator * generator;

@end
