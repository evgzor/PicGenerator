//
//  MHCameraRoll.h
//  pxlcld-ios
//
//  Created by  Evgeny Zorin on 3/19/14.
//

#import <Foundation/Foundation.h>

@import UIKit;
@import CoreLocation;
@import ImageIO;
#import "UtilsHelper.h"

@interface PhotoCameraRoll : NSObject

typedef NS_ENUM(NSInteger, PhotoCameraRollFileTypes) {
    MHCameraRollFileTypesAll,
    MHCameraRollFileTypesScreenshots,
    MHCameraRollFileTypesPhotos
};

typedef NS_ENUM(NSInteger, PhotoCameraRollThumbStyle) {
    MHCameraRollThumbStyleSmallSquare,
    MHCameraRollThumbStyleOriginalRatio
};

@property (nonatomic, assign) PhotoCameraRollFileTypes fileTypes;
@property (nonatomic, assign) PhotoCameraRollThumbStyle thumbStyle;
/**
 *  load pictures from camera roll
 *
 *  @param success      pass if granted permisions
 *  @param unauthorized for restricted permisssions
 */
- (void)loadCameraRollWithSuccess:(void(^)(void))success unauthorized:(void(^)(void))unauthorized;

@property (nonatomic, readonly) NSInteger imageCount;
/**
 *  Retrieve filename in galery
 *
 *  @param index index image in gallery
 *
 *  @return full file name
 */
- (NSString *)fileNameAtIndex:(NSInteger)index;
/**
 *  Retrieve url image from gallery
 *
 *  @param index index image in gallery
 *
 *  @return full path to image
 */
- (NSString *)fileURLAtIndex:(NSInteger)index;
/**
 *  Retrieve thumb
 *
 *  @param index             index thumb in gallery
 *  @param completionHandler completionHandler finishing extraction
 */
- (void)thumbAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *thumb))completionHandler;
/**
 *  Retrieve full size image
 *
 *  @param index             index image in gallery
 *  @param completionHandler completionHandler finishing extraction
 */
- (void)imageAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *image))completionHandler;
/**
 *  Retrieve CGIImage
 *
 *  @param index             index image in gallery
 *  @param completionHandler completionHandler finishing extraction
 */
- (void)CGImageAtIndex:(NSInteger)index completionHandler:(void(^)(CGImageRef CGImage))completionHandler;
/**
 *  Retrieves metadata from photogalery at index
 *
 *  @param index             index of pphoto in galery
 *  @param completionHandler asynchronosly finished
 */
- (void)metaDataAtIndex:(NSInteger)index completionHandler:(void(^)(NSDictionary *metaData))completionHandler;

@end
