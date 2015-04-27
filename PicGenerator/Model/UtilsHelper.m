//
//  UtilsHelper.m
//  PicGenerator
//
//  Created by admin on 26.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "UtilsHelper.h"


@implementation NSArray(utils)


-(void)applySelector:(SEL)selector withArgument:(id)object
{
    [self enumerateObjectsUsingBlock:^(id element, NSUInteger index, BOOL *stop){
        //SEL selector = NSSelectorFromString(@"someMethod");
        if ([element respondsToSelector:selector]) {
    IMP imp                                                 = [element methodForSelector:selector];
    void (*func)(id, SEL,id)                                = (void *)imp;
            func(element, selector,object);
        }
    }];
}


@end


@implementation UIImage(drawText)

-(UIImage*) drawText:(NSString*) text
             atPoint:(CGPoint)   point withFontSize:(CGFloat)fontSize andTextColor:(UIColor*)textColor andBackgroundColor:(UIColor*)backgroundColor;
{

    NSMutableAttributedString *textStyle                    = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",text]];

    // text color
    [textStyle addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, textStyle.length)];

    // text font
    [textStyle addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, textStyle.length)];

    NSMutableParagraphStyle *paragraphStyle                 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [textStyle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, textStyle.length)];

    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0,0, self.size.width, self.size.height)];
    CGRect rect                                             = CGRectMake(point.x, point.y, self.size.width, self.size.height);
    [[UIColor whiteColor] set];

    // add text onto the image
    CGContextRef context                                    = UIGraphicsGetCurrentContext();

    CGFloat red,green,blue,alpha;
    [backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];

    CGContextSetRGBFillColor(context, red, blue, green, alpha);
    CGContextFillRect(context, rect);

    [textStyle drawInRect:CGRectIntegral(rect)];

    UIImage *newImage                                       = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect                                             = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context                                    = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image                                          = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void) saveImageWithInfo:(NSDictionary *)info forLocation:(CLLocation *)location
{
    // Get the assets library
    ALAssetsLibrary *library                                = [[ALAssetsLibrary alloc] init];

    // Get the image metadata (EXIF & TIFF)
    NSMutableDictionary * imageMetadata                     = [info mutableCopy];//[[info objectForKey:UIImagePickerControllerMediaMetadata] mutableCopy];

    // add GPS data
    CLLocation * loc                                        = location;// need a location here
    if ( loc ) {
    imageMetadata[(NSString*)kCGImagePropertyGPSDictionary] = [loc gpsDictionaryForLocation];
    }

    ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image %@ with metadata %@ to Photo Library",newURL,imageMetadata);
        }
    };

    // Save the new image to the Camera Roll
    [library writeImageToSavedPhotosAlbum:[self CGImage]
                                 metadata:imageMetadata
                          completionBlock:imageWriteCompletionBlock];

}


-(UIImage*)imageByRotatingImageFromImageOrientation:(UIImageOrientation)orientation
{
    CGImageRef imgRef                                       = self.CGImage;

    CGFloat width                                           = CGImageGetWidth(imgRef);
    CGFloat height                                          = CGImageGetHeight(imgRef);

    CGAffineTransform transform                             = CGAffineTransformIdentity;
    CGRect bounds                                           = CGRectMake(0, 0, width, height);
    CGSize imageSize                                        = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient                               = orientation;
    switch(orient) {

        case UIImageOrientationUp: //EXIF = 1
            return self;
            break;

        case UIImageOrientationUpMirrored: //EXIF = 2
    transform                                               = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
    transform                                               = CGAffineTransformScale(transform, -1.0, 1.0);
            break;

        case UIImageOrientationDown: //EXIF = 3
    transform                                               = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
    transform                                               = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationDownMirrored: //EXIF = 4
    transform                                               = CGAffineTransformMakeTranslation(0.0, imageSize.height);
    transform                                               = CGAffineTransformScale(transform, 1.0, -1.0);
            break;

        case UIImageOrientationLeftMirrored: //EXIF = 5
    boundHeight                                             = bounds.size.height;
    bounds.size.height                                      = bounds.size.width;
    bounds.size.width                                       = boundHeight;
    transform                                               = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
    transform                                               = CGAffineTransformScale(transform, -1.0, 1.0);
    transform                                               = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationLeft: //EXIF = 6
    boundHeight                                             = bounds.size.height;
    bounds.size.height                                      = bounds.size.width;
    bounds.size.width                                       = boundHeight;
    transform                                               = CGAffineTransformMakeTranslation(0.0, imageSize.width);
    transform                                               = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;

        case UIImageOrientationRightMirrored: //EXIF = 7
    boundHeight                                             = bounds.size.height;
    bounds.size.height                                      = bounds.size.width;
    bounds.size.width                                       = boundHeight;
    transform                                               = CGAffineTransformMakeScale(-1.0, 1.0);
    transform                                               = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        case UIImageOrientationRight: //EXIF = 8
    boundHeight                                             = bounds.size.height;
    bounds.size.height                                      = bounds.size.width;
    bounds.size.width                                       = boundHeight;
    transform                                               = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
    transform                                               = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;

        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];

    }
    // Create the bitmap context
    CGContextRef    context                                 = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;

    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow                                       = (bounds.size.width * 4);
    bitmapByteCount                                         = (bitmapBytesPerRow * bounds.size.height);
    bitmapData                                              = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        return nil;
    }

    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    CGColorSpaceRef colorspace                              = CGImageGetColorSpace(imgRef);
    context                                                 = CGBitmapContextCreate (bitmapData,bounds.size.width,bounds.size.height,8,bitmapBytesPerRow,
                                     colorspace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);

    if (context == NULL)
        // error creating context
        return nil;

    CGContextScaleCTM(context, -1.0, -1.0);
    CGContextTranslateCTM(context, -bounds.size.width, -bounds.size.height);

    CGContextConcatCTM(context, transform);

    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(context, CGRectMake(0,0,width, height), imgRef);

    CGImageRef imgRef2                                      = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    free(bitmapData);
    UIImage * image                                         = [UIImage imageWithCGImage:imgRef2 scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef2);
    return image;
}


@end

@implementation CLLocation(GPS)


- (NSDictionary *) gpsDictionaryForLocation
{
    CLLocationDegrees exifLatitude                          = self.coordinate.latitude;
    CLLocationDegrees exifLongitude                         = self.coordinate.longitude;

    NSString * latRef;
    NSString * longRef;
    if (exifLatitude < 0.0) {
    exifLatitude                                            = exifLatitude * -1.0f;
    latRef                                                  = @"S";
    } else {
    latRef                                                  = @"N";
    }

    if (exifLongitude < 0.0) {
    exifLongitude                                           = exifLongitude * -1.0f;
    longRef                                                 = @"W";
    } else {
    longRef                                                 = @"E";
    }

    NSMutableDictionary *locDict                            = [[NSMutableDictionary alloc] init];

    NSDateFormatter *formatter                              = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSSSSS"];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    locDict[(NSString *)kCGImagePropertyGPSTimeStamp]       = [formatter stringFromDate:self.timestamp];
    [formatter setDateFormat:@"yyyy:MM:dd"];
    locDict[(NSString *)kCGImagePropertyGPSDateStamp]       = [formatter stringFromDate:self.timestamp];

    locDict[(NSString*)kCGImagePropertyGPSLatitudeRef]      = latRef;
    locDict[(NSString *)kCGImagePropertyGPSLatitude]        = @(exifLatitude);
    locDict[(NSString*)kCGImagePropertyGPSLongitudeRef]     = longRef;
    locDict[(NSString *)kCGImagePropertyGPSLongitude]       = @(exifLongitude);
    locDict[(NSString*)kCGImagePropertyGPSDOP]              = @(self.horizontalAccuracy);
    locDict[(NSString*)kCGImagePropertyGPSAltitude]         = @(self.altitude);

    return locDict;
}

- (void)locationForCompletition:(void(^)(NSString *locateAt))completionHandler
{
    CLGeocoder *ceo                                         = [[CLGeocoder alloc]init];

    [ceo reverseGeocodeLocation: self completionHandler:
     ^(NSArray *placemarks, NSError *error) {
    CLPlacemark *placemark                                  = placemarks[0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
    NSString *locatedAt                                     = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"addressDictionary %@", placemark.addressDictionary);

         NSLog(@"placemark %@",placemark.region);
         NSLog(@"placemark %@",placemark.country);  // Give Country Name
         NSLog(@"placemark %@",placemark.locality); // Extract the city name
         NSLog(@"location %@",placemark.name);
         NSLog(@"location %@",placemark.ocean);
         NSLog(@"location %@",placemark.postalCode);
         NSLog(@"location %@",placemark.subLocality);

         NSLog(@"location %@",placemark.location);
         //Print the location to console
         NSLog(@"currently at %@",locatedAt);

         completionHandler(locatedAt);
     }];
}

+(BOOL)getLocationStringRepresentation:(NSString**)string forMetaData:(NSDictionary*)metaData
{
    NSDictionary* locDict                                   = metaData[(NSString*)kCGImagePropertyGPSDictionary];

    float laltitude                                         = [locDict[(NSString*)kCGImagePropertyGPSLatitude] floatValue];
    float longitude                                         = [locDict[(NSString*)kCGImagePropertyGPSLongitude] floatValue];

    NSString* timeStamp                                     = locDict[(NSString*)kCGImagePropertyGPSTimeStamp];
    NSString* dateStamp                                     = locDict[(NSString *)kCGImagePropertyGPSDateStamp];

    float altitude                                          = [locDict[(NSString*)kCGImagePropertyGPSAltitude] floatValue];

    NSString* longitudeRef                                  = locDict[(NSString*)kCGImagePropertyGPSLongitudeRef];
    NSString* latitudeRef                                   = locDict[(NSString*)kCGImagePropertyGPSLatitudeRef];
    float dop                                               = [locDict[(NSString*)kCGImagePropertyGPSDOP] floatValue];

    *string                                                 = [NSString stringWithFormat:@"Altitude:%3.3f, DOP:%3f Latitude:%3.3f, LatitudeRef:%@ Longitude:%3.3f LongitudeRef:%@, time:%@, date:%@",altitude,dop,laltitude,latitudeRef,longitude,longitudeRef,timeStamp ? timeStamp : @"",dateStamp ? dateStamp : @""];

    if (laltitude && longitude) {
        return YES;
    }

    return NO;
}


@end

@implementation UtilsHelper


@end
