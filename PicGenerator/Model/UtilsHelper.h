//
//  UtilsHelper.h
//  PicGenerator
//
//  Created by admin on 26.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
@import ImageIO;
@import UIKit;
@import CoreLocation;
#import <AssetsLibrary/AssetsLibrary.h>

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif

@interface NSArray(utils)

-(void)applySelector:(SEL)selector withArgument:(id)object;

@end

@interface CLLocation(GPS)

- (NSDictionary *) gpsDictionaryForLocation;

- (void)locationForCompletition:(void(^)(NSString *locateAt))completionHandler;

+ (BOOL)getLocationStringRepresentation:(NSString**)string forMetaData:(NSDictionary*)metaData;

@end

@interface UIImage(drawText)

-(UIImage*) drawText:(NSString*) text
             atPoint:(CGPoint)   point withFontSize:(CGFloat)fontSize andTextColor:(UIColor*)textColor andBackgroundColor:(UIColor*)backgroundColor;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

- (void) saveImageWithInfo:(NSDictionary *)info forLocation:(CLLocation *)location;

- (UIImage*)imageByRotatingImageFromImageOrientation:(UIImageOrientation)orientation;


@end

@interface UtilsHelper : NSObject

@end
