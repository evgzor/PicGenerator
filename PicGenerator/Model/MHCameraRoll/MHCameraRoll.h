//
//  MHCameraRoll.h
//  pxlcld-ios
//
//  Created by Matej Hrescak and Evgeny Zorin on 3/19/14.
//  Copyright (c) 2014 facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import CoreLocation;
@import ImageIO;

@interface MHCameraRoll : NSObject

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

- (NSInteger)imageCount;
- (NSString *)fileNameAtIndex:(NSInteger)index;
- (NSString *)fileURLAtIndex:(NSInteger)index;
- (void)thumbAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *thumb))completionHandler;
- (void)imageAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *image))completionHandler;
- (void)CGImageAtIndex:(NSInteger)index completionHandler:(void(^)(CGImageRef CGImage))completionHandler;
- (void)metaDataAtIndex:(NSInteger)index completionHandler:(void(^)(NSDictionary *metaData))completionHandler;

+ (NSDictionary *) gpsDictionaryForLocation:(CLLocation *)location;
+ (BOOL)getLocation:(CLLocation **)location andStringRepresentation:(NSString**)string forMetaData:(NSDictionary*)metaData;
+ (void) saveImage:(UIImage *)imageToSave withInfo:(NSDictionary *)info forLocation:(CLLocation *)location;
+ (void)location: (CLLocation*)location forCompletition:(void(^)(NSString *locateAt))completionHandler;

@end
