//
//  ThirdViewController.m
//  PicGenerator
//
//  Created by Zorin Evgeny on 24.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "ThirdViewController.h"
#import <Foundation/Foundation.h>
#import "CameraViewController.h"
#import "PhotoCameraRoll.h"
#import "CollectionCell.h"
#import "PhotoFromLibViewController.h"

@interface ThirdViewController ()  <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak  ) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak  ) IBOutlet UIView           *unauthorizedView;
@property (nonatomic, strong) PhotoCameraRoll  *cameraRoll;

@end

@implementation ThirdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *anotherButton         = [[UIBarButtonItem alloc] initWithTitle:@"Camera" style:UIBarButtonItemStylePlain target:self action:@selector(showCamera:)];
    self.navigationItem.rightBarButtonItem = anotherButton;

    UINib *nib                             = [UINib nibWithNibName:@"CollectionCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"collectionCell"];
    self.collectionView.dataSource         = self;
    self.collectionView.delegate           = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUpdatedData) name:ALAssetsLibraryChangedNotification object:nil];
    [self reloadUpdatedData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - memory managment
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _collectionView.delegate   = nil;
    _collectionView.dataSource = nil;
    _cameraRoll                = nil;
}

-(void)reloadUpdatedData
{
    self.cameraRoll              = [[PhotoCameraRoll alloc] init];
    self.cameraRoll.fileTypes    = MHCameraRollFileTypesAll;//don't filter by type
    self.cameraRoll.thumbStyle   = MHCameraRollThumbStyleSmallSquare;//make scale to be a third of the screen

    [self.cameraRoll loadCameraRollWithSuccess:^{
        // camera roll has loaded images, this is a good place to call reloadData
        // on your table or collection view and hide view for unauthorized state
        // and reload collectionview's data.
    self.unauthorizedView.hidden = YES;
        dispatch_async(dispatch_get_main_queue(), ^
                      {
                          [self.collectionView reloadData];

                      });
    } unauthorized:^{
        // unauthorized state: access to camera roll was denied by the user so
        // we should show an unauthorized state with text explaining how to
        // re-authorize the app to use camera roll.
    self.unauthorizedView.hidden = NO;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cameraRoll imageCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    if (_cameraRoll.imageCount-1 >=indexPath.row) {
        [self.cameraRoll thumbAtIndex:indexPath.row completionHandler:^(UIImage *thumb) {
            cell.image.image     = thumb;
        }];
    }
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0., 5., 0., 5.);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard               = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    PhotoFromLibViewController*contentPage = [storyboard instantiateViewControllerWithIdentifier:@"detailImage"];

    [self.cameraRoll metaDataAtIndex:indexPath.row completionHandler:^(NSDictionary* metadata) {

        NSLog(@"attachements: %@", metadata);

        [self.cameraRoll imageAtIndex:indexPath.row completionHandler:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [contentPage setUpImage:image andMetaData:metadata];
                               [self.navigationController pushViewController:contentPage animated:YES];

                           });
        }];

    }];
}

#pragma mark - user action

-(void)showCamera:(id)sender
{
    UIStoryboard *storyboard         = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CameraViewController*contentPage = [storyboard instantiateViewControllerWithIdentifier:@"camera"];

    [self.navigationController pushViewController:contentPage animated:YES];
}


@end
