//
//  MHCameraRoll.m
//  pxlcld-ios
//
//  Created by Matej Hrescak on 3/19/14.
//  Copyright (c) 2014 facebook. All rights reserved.
//

#import "MHCameraRoll.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface MHCameraRoll()

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableDictionary *thumbCache;

@end

@implementation MHCameraRoll

- (id)init
{
    self = [super init];
    if (self) {
        self.library = [[ALAssetsLibrary alloc] init];
        self.fileTypes = MHCameraRollFileTypesAll;
        self.thumbStyle = MHCameraRollThumbStyleSmallSquare;
        self.images = [[NSMutableArray alloc] init];
        self.thumbCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - loading

- (void)loadCameraRollWithSuccess:(void(^)(void))success
                     unauthorized:(void(^)(void))unauthorized
{
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied ||
        [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
        unauthorized();
    } else {
        [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsWithOptions:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
                if (alAsset) {
                    ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                    NSString *fileName = [representation filename];
                    if ([self shouldReadFileOfExtension:[fileName pathExtension]]) {
                        NSDictionary *image = @{@"fileName": fileName,
                                                @"URL": [representation url]};
                        [self.images addObject:image];
                    }
                }
            }];
            success();
            
        } failureBlock:^(NSError *error) {
            if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                NSLog(@"user denied access to camera roll, code: %li",(long)error.code);
                unauthorized();
            }else{
                NSLog(@"Other camera roll error code: %li",(long)error.code);
            }
        }];
    }
}

#pragma mark - custom style setter

- (void)setThumbStyle:(MHCameraRollThumbStyle)thumbStyle
{
    _thumbStyle = thumbStyle;
    //purge the thumb cache since the scale is not relevant anymore
    [self.thumbCache removeAllObjects];
}

#pragma mark - image access

- (NSInteger)imageCount
{
    return [self.images count];
}

- (NSString *)fileNameAtIndex:(NSInteger)index
{
    NSString *fileName = @"";
    NSDictionary *image = [self.images objectAtIndex:index];
    if (image) {
        fileName = [image objectForKey:@"fileName"];
    }
    
    return fileName;
}

- (NSString *)fileURLAtIndex:(NSInteger)index
{
    NSString *filePath = @"";
    NSDictionary *image = [self.images objectAtIndex:index];
    if (image) {
        filePath = [image objectForKey:@"URL"];
    }
    
    return filePath;
}

- (void)thumbAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *thumb))completionHandler
{
    UIImage *thumb = self.thumbCache[[NSNumber numberWithInteger:index]];
    if (thumb) {
        //return cached thumbnail if we have one
        completionHandler(thumb);
    } else {
        //create new one and save to cache if we don't
        [self.library assetForURL:self.images[index][@"URL"] resultBlock:^(ALAsset *asset) {
            UIImage *thumb = [[UIImage alloc] init];
            if (self.thumbStyle == MHCameraRollThumbStyleSmallSquare) {
                thumb = [UIImage imageWithCGImage:[asset thumbnail]];
            } else {
                thumb = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            }
            [self.thumbCache setObject:thumb forKey:[NSNumber numberWithInteger:index]];
            completionHandler(thumb);
        } failureBlock:^(NSError *error) {
            NSLog(@"Error loading asset");
        }];
    }
}

- (void)imageAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *image))completionHandler
{
    NSDictionary *image = self.images[index];
    [self.library assetForURL:image[@"URL"] resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        UIImage *returnImage = [UIImage imageWithCGImage:[representation fullResolutionImage]
                                                   scale:[representation scale]
                                             orientation:(int)[representation orientation]];
        completionHandler(returnImage);
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading asset");
    }];
}

- (void)metaDataAtIndex:(NSInteger)index completionHandler:(void(^)(NSDictionary *metaData))completionHandler
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         
         // Within the group enumeration block, filter to enumerate just photos.
         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
         
         // For this example, we're only interested in the first item.
         [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:index]
                                 options:0
                              usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop)
          {
              
              // The end of the enumeration is signaled by asset == nil.
              if (alAsset) {
                  ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                  NSDictionary *imageMetadata = [representation metadata];
                  // Do something interesting with the metadata.
                  
                  completionHandler(imageMetadata);
 
              }
          }];
     }
                         failureBlock: ^(NSError *error)
     {
         // Typically you should handle an error more gracefully than this.
         NSLog(@"No groups");
     }];
}

- (void)CGImageAtIndex:(NSInteger)index completionHandler:(void(^)(CGImageRef CGImage))completionHandler
{
    NSDictionary *image = self.images[index];
    [self.library assetForURL:image[@"URL"] resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        completionHandler([representation fullResolutionImage]);
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading asset");
    }];
}

#pragma mark - helper methods

-(BOOL)shouldReadFileOfExtension:(NSString *)extension{
    if (self.fileTypes == MHCameraRollFileTypesAll) {
        //load all images
        return YES;
    } else if (self.fileTypes == MHCameraRollFileTypesPhotos){
        //load only photos
        return [extension isEqualToString:@"JPEG"] ||
                [extension isEqualToString:@"jpeg"] ||
                [extension isEqualToString:@"jpg"] ||
                [extension isEqualToString:@"JPG"];
    } else if (self.fileTypes == MHCameraRollFileTypesScreenshots){
        // load only screenshots
        return [extension isEqualToString:@"PNG"] ||
        [extension isEqualToString:@"png"];
    }
    return NO;
}

+ (NSDictionary *) gpsDictionaryForLocation:(CLLocation *)location
{
    CLLocationDegrees exifLatitude  = location.coordinate.latitude;
    CLLocationDegrees exifLongitude = location.coordinate.longitude;
    
    NSString * latRef;
    NSString * longRef;
    if (exifLatitude < 0.0) {
        exifLatitude = exifLatitude * -1.0f;
        latRef = @"S";
    } else {
        latRef = @"N";
    }
    
    if (exifLongitude < 0.0) {
        exifLongitude = exifLongitude * -1.0f;
        longRef = @"W";
    } else {
        longRef = @"E";
    }
    
    NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSSSSS"];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [locDict setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSTimeStamp];
    [formatter setDateFormat:@"yyyy:MM:dd"];
    [locDict setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSDateStamp];
    
    [locDict setObject:latRef forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLatitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    [locDict setObject:longRef forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLongitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    [locDict setObject:[NSNumber numberWithFloat:location.horizontalAccuracy] forKey:(NSString*)kCGImagePropertyGPSDOP];
    [locDict setObject:[NSNumber numberWithFloat:location.altitude] forKey:(NSString*)kCGImagePropertyGPSAltitude];
    
    return locDict;
    
}


+(BOOL)getLocation:(CLLocation **)location andStringRepresentation:(NSString**)string forMetaData:(NSDictionary*)metaData
{
    NSDictionary* locDict = metaData[(NSString*)kCGImagePropertyGPSDictionary];
    
    float laltitude = [locDict[(NSString*)kCGImagePropertyGPSLatitude] floatValue];
    float longitude = [locDict[(NSString*)kCGImagePropertyGPSLongitude] floatValue];
    *location = [[CLLocation alloc] initWithLatitude:laltitude longitude:longitude];
    
    NSString* timeStamp = locDict[(NSString*)kCGImagePropertyGPSTimeStamp];
    NSString* dateStamp = locDict[(NSString *)kCGImagePropertyGPSDateStamp];
    
    float altitude = [locDict[(NSString*)kCGImagePropertyGPSAltitude] floatValue];
    
    NSString* longitudeRef = locDict[(NSString*)kCGImagePropertyGPSLongitudeRef];
    NSString* latitudeRef = locDict[(NSString*)kCGImagePropertyGPSLatitudeRef];
    float dop = [locDict[(NSString*)kCGImagePropertyGPSDOP] floatValue];
    
    *string = [NSString stringWithFormat:@"Altitude:%3.3f, DOP:%3f Latitude:%3.3f, LatitudeRef:%@ Longitude:%3.3f LongitudeRef:%@, time:%@, date:%@",altitude,dop,laltitude,latitudeRef,longitude,longitudeRef,timeStamp ? timeStamp : @"",dateStamp ? dateStamp : @""];
        
    if (laltitude && longitude) {
        return YES;
    }
    
    return NO;
}

+ (void) saveImage:(UIImage *)imageToSave withInfo:(NSDictionary *)info forLocation:(CLLocation *)location
{
    // Get the assets library
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Get the image metadata (EXIF & TIFF)
    NSMutableDictionary * imageMetadata = [info mutableCopy];//[[info objectForKey:UIImagePickerControllerMediaMetadata] mutableCopy];
    
    // add GPS data
    CLLocation * loc = location; // need a location here
    if ( loc ) {
        [imageMetadata setObject:[MHCameraRoll gpsDictionaryForLocation:loc] forKey:(NSString*)kCGImagePropertyGPSDictionary];
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
    [library writeImageToSavedPhotosAlbum:[imageToSave CGImage]
                                 metadata:imageMetadata
                          completionBlock:imageWriteCompletionBlock];
    
}

+ (void)location: (CLLocation*)location forCompletition:(void(^)(NSString *locateAt))completionHandler
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    
    [ceo reverseGeocodeLocation: location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
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



@end
