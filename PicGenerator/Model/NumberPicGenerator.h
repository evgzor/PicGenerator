//
//  NumberPicGenerator.h
//  PicGenerator
//
//  Created by admin on 26.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol  NumberPicGeneratorDelegate;


@interface NumberPicGenerator : NSObject

@property (readonly) BOOL isStarted;

-(void)start;
-(void)pause;

- (void)addDelegate:(id<NumberPicGeneratorDelegate>) delegate;
- (void)remooveDelagate:(id<NumberPicGeneratorDelegate>) delegate;

@end

@protocol NumberPicGeneratorDelegate <NSObject>

@required

- (void) updateState;

@optional

- (void)evenUpdatedIdmage:(UIImage*)image;
- (void)unevenUpdatedImage:(UIImage*)image;

@end