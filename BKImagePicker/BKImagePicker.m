//
//  BKImagePicker.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePicker.h"
#import "BKImagePickerHeader.h"
#import "BKIPImageAlbumListViewController.h"
#import "BKIPImagePickerViewController.h"

@interface BKImagePicker()

@property (nonatomic,strong) id observer;//通知观察者

@end

@implementation BKImagePicker

#pragma mark - 单例

static BKImagePicker * sharedManager = nil;
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [super allocWithZone:zone];
    });
    return sharedManager;
}

#pragma mark - 相册

/**
 相册
 */
-(void)showImageAlbumWithDisplayType:(BKIPDisplayType)displayType maxSelect:(NSInteger)maxSelect isHaveOriginal:(BOOL)isHaveOriginal complete:(void (^)(PHAsset * asset, UIImage * image, NSData * data, NSURL * url, BKIPSelectType selectType))complete
{
    [[BKImagePickerShareManager sharedManager].imagePickerModel resetProperty];
    [BKImagePickerShareManager sharedManager].imagePickerModel.isHaveOriginal = isHaveOriginal;
    [BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect = maxSelect > 999 ? 999 : maxSelect;
    [BKImagePickerShareManager sharedManager].imagePickerModel.displayType = displayType;
    
    [self skipImagePickerVCWithComplete:^(PHAsset *asset, UIImage *image, NSData *data, NSURL *url, BKIPSelectType selectType) {
        if (complete) {
            complete(asset, image, data, url, selectType);
        }
    }];
}

/**
 相册 + 裁剪
 */
-(void)showImageAlbumWithDisplayType:(BKIPDisplayType)displayType aspectRatio:(CGFloat)aspectRatio isHaveOriginal:(BOOL)isHaveOriginal complete:(void (^)(PHAsset * asset, UIImage * image, NSData * data, NSURL * url, BKIPSelectType selectType))complete
{
    NSAssert(displayType == BKIPDisplayTypeDefault || displayType == BKIPDisplayTypeImageAndVideo, @"不能选取裁剪视频");
    
    [[BKImagePickerShareManager sharedManager].imagePickerModel resetProperty];
    [BKImagePickerShareManager sharedManager].imagePickerModel.isHaveOriginal = isHaveOriginal;
    [BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect = 1;
    [BKImagePickerShareManager sharedManager].imagePickerModel.displayType = displayType;
    
    [self skipImagePickerVCWithComplete:^(PHAsset *asset, UIImage *image, NSData *data, NSURL *url, BKIPSelectType selectType) {
        if (complete) {
            complete(asset, image, data, url, selectType);
        }
    }];
}

-(void)skipImagePickerVCWithComplete:(void (^)(PHAsset * asset, UIImage * image, NSData * data, NSURL * url, BKIPSelectType selectType))complete
{
    [[BKImagePickerShareManager sharedManager] checkAllowVisitPhotoAlbumHandler:^(BOOL flag) {
        if (flag) {
            UIViewController * lastVC = self.bk_displayViewController;
            
            //相机胶卷相簿
            PHFetchResult * userLibrary = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
            PHAssetCollection * collection = userLibrary.firstObject;
            
            BKIPImageAlbumListViewController * imageClassVC = [[BKIPImageAlbumListViewController alloc] init];
            imageClassVC.title = @"相册";
            
            BKIPImagePickerViewController * imageVC = [[BKIPImagePickerViewController alloc] init];
            imageVC.title = collection.localizedTitle;
            
            self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:kBKIPFinishSelectImageNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                for (BKImagePickerImageModel * model in [BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray) {
                    if (complete) {
                        if (model.photoType != BKIPSelectTypeVideo) {
                            if ([BKImagePickerShareManager sharedManager].imagePickerModel.isOriginal) {
                                complete(model.asset, [UIImage imageWithData:model.originalImageData], model.originalImageData, model.url, model.photoType);
                            }else {
                                complete(model.asset, [UIImage imageWithData:model.thumbImageData], model.thumbImageData, model.url, model.photoType);
                            }
                        }else {
                            complete(model.asset, [[BKImagePickerShareManager sharedManager] getFirstFrameWithVideoURLAsset:model.avURLAsset], [NSData dataWithContentsOfURL:model.url], model.url, model.photoType);
                        }
                    }
                }
                [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
            }];
            
            BKImagePickerNavigationController * nav = [[BKImagePickerNavigationController alloc] initWithRootViewController:imageClassVC];
            [nav pushViewController:imageVC animated:NO];
            nav.popVC = imageClassVC;
            [lastVC presentViewController:nav animated:YES completion:nil];
        }
    } alertHandler:nil];
}

@end
