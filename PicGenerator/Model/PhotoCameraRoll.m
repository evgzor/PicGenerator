//
//  MHCameraRoll.m
//  pxlcld-ios
//
//

#import "PhotoCameraRoll.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface PhotoCameraRoll()

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) NSMutableDictionary *thumbCache;

@end

@implementation PhotoCameraRoll

- (instancetype)init
{
    self = [super init];
    if (self) {
        _library = [[ALAssetsLibrary alloc] init];
        _fileTypes = MHCameraRollFileTypesAll;
        _thumbStyle = MHCameraRollThumbStyleSmallSquare;
        _images = [[NSMutableArray alloc] init];
        _thumbCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    _library = nil;
    _images = nil;
    _thumbCache = nil;
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
    NSDictionary *image = (self.images)[index];
    if (image) {
        fileName = image[@"fileName"];
    }
    
    return fileName;
}

- (NSString *)fileURLAtIndex:(NSInteger)index
{
    NSString *filePath = @"";
    NSDictionary *image = (self.images)[index];
    if (image) {
        filePath = image[@"URL"];
    }
    
    return filePath;
}

- (void)thumbAtIndex:(NSInteger)index completionHandler:(void(^)(UIImage *thumb))completionHandler
{
    UIImage *thumb = self.thumbCache[@(index)];
    if (thumb) {
        //return cached thumbnail if we have one
        completionHandler(thumb);
    } else {
        //create new one and save to cache if we don't
        [self.library assetForURL:self.images[index][@"URL"] resultBlock:^(ALAsset *asset) {
            UIImage *thumb;
            if (self.thumbStyle == MHCameraRollThumbStyleSmallSquare) {
                thumb = [UIImage imageWithCGImage:[asset thumbnail]];
            } else {
                thumb = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            }
            (self.thumbCache)[@(index)] = thumb;
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


@end
