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
/**
 *  Indicates generator status
 */
@property (readonly) BOOL isStarted;

/**
 *  start timer counter
 */
-(void)start;

/**
 *  Pause and invalidate timer
 */
-(void)pause;
/**
 *  add delegate object to private storage
 *
 *  @param delegate object with conforms with NumberPicGeneratorDelegate
 */
- (void)addDelegate:(id<NumberPicGeneratorDelegate>) delegate;
/**
 *  Remove object from internal storage
 *
 *  @param delegate delegate object with conforms with NumberPicGeneratorDelegate
 */
- (void)remooveDelagate:(id<NumberPicGeneratorDelegate>) delegate;

@end
/**
 *  Communication Data protocol for updting info
 */
@protocol NumberPicGeneratorDelegate <NSObject>

@required
/**
 *  update state delegates
 */
- (void) updateState;

@optional
/**
 *  Call delegate only for even generated number
 *
 *  @param image generated UIImage with text
 */
- (void)evenUpdatedIdmage:(UIImage*)image;
/**
 *  Call delegates only for odd numbers
 *
 *  @param image image generated UIImage with text
 */
- (void)unevenUpdatedImage:(UIImage*)image;

@end