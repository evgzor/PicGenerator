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

typedef NS_ENUM(NSInteger, MHCameraRollFileTypes) {
    MHCameraRollFileTypesAll,
    MHCameraRollFileTypesScreenshots,
    MHCameraRollFileTypesPhotos
};

typedef NS_ENUM(NSInteger, MHCameraRollThumbStyle) {
    MHCameraRollThumbStyleSmallSquare,
    MHCameraRollThumbStyleOriginalRatio
};

@property (nonatomic, assign) MHCameraRollFileTypes fileTypes;
@property (nonatomic, assign) MHCameraRollThumbStyle thumbStyle;

- (void)loadCameraRollWithSuccess:(void(^)(void))success unauthorized:(void(^)(void))unauthorized;

@property (nonatomic, readonly) NSInteger imageCount;
- (NSString *)fileNameAtIndex:(NSInteger)index;
- (NSString *)fileURLAtIndex:(NSInteger)index;
- (void)thumbAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *thumb))completionHandler;
- (void)imageAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *image))completionHandler;
- (void)CGImageAtIndex:(NSInteger)index completionHandler:(void(^)(CGImageRef CGImage))completionHandler;
- (void)metaDataAtIndex:(NSInteger)index completionHandler:(void(^)(NSDictionary *metaData))completionHandler;

@end
