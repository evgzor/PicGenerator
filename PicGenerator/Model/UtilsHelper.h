//
//  UtilsHelper.h
//  PicGenerator
//
//  Created by admin on 26.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AssetsLibrary;
@import ImageIO;
@import UIKit;
@import CoreLocation;

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

@interface NSArray(utils)
/**
 *  Universal method for apply to all object in array like makeobject in NSArray but doing verifification with respond to selector
 *
 *  @param selector method to perform with max one argument
 *  @param object   argument function object
 */
-(void)applySelector:(SEL)selector withArgument:(id)object;

@end

@interface CLLocation(GPS)
/**
 *  Create dictinary with gps data for meta data of image
 *
 *  @return info description dictionary gps data
 */
- (NSDictionary *) gpsDictionaryForLocation;

/**
 *  Retrieve text address by location coordinate
 *
 *  @param completionHandler comletes asynchronosly with asdress string
 */
- (void)locationForCompletition:(void(^)(NSString *locateAt))completionHandler;

/**
 *  Generate text from dictionary with custimization representation and verification that data is not empty by returning BOOL status
 *
 *  @param string   returning pointer on generated string
 *  @param metaData GPS picture methadata
 *
 *  @return status verification true if data not empty
 */
+ (BOOL)getLocationStringRepresentation:(NSString**)string forMetaData:(NSDictionary*)metaData;

@end

@interface UIImage(drawText)
/**
 *  Drawwing text string on UIImage with background customization and position alighnment center
 *
 *  @param text            NSString string info
 *  @param point           CGPoint starting drawing
 *  @param fontSize        fontSize customize representation text size
 *  @param textColor       textColor customize representation text color
 *  @param backgroundColor backgroundColor customize representation background color
 *
 *  @return generated resulting uiimage with text
 */
-(UIImage*) drawText:(NSString*) text
             atPoint:(CGPoint)   point withFontSize:(CGFloat)fontSize andTextColor:(UIColor*)textColor andBackgroundColor:(UIColor*)backgroundColor;
/**
 *  Generate UIImage sized and proper colored
 *
 *  @param color custom UIColor
 *  @param size  size of image generation
 *
 *  @return generated custom collored uimage
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/**
 *  Save image to photo gallery destination with GPS metadata info
 *
 *  @param info     original methadata
 *  @param location location data
 */
- (void) saveImageWithInfo:(NSDictionary *)info forLocation:(CLLocation *)location;
/**
 *  Rotate image to UIImageOrientation point
 *
 *  @param orientation UIImageOrientation as above but image mirrored along other axis. horizontal flip and 90 degree 
 *
 *  @return generated final rotated image
 */
- (UIImage*)imageByRotatingImageFromImageOrientation:(UIImageOrientation)orientation;


@end

@interface UtilsHelper : NSObject

@end
