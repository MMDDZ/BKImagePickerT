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
//    [[BKImagePickerShareManager sharedManager] checkAllowVisitPhotoAlbumHandler:^(BOOL flag) {
//        if (flag) {
//            UIViewController * lastVC = self.bk_displayViewController;
//            
//            __block NSString * albumName = @"";
//            //系统的相簿
//            PHFetchResult * smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
//            [smartAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                PHAssetCollection *collection = obj;
//                
//                // 获取所有资源的集合按照创建时间倒序排列
//                PHFetchOptions * fetchOptions = [[PHFetchOptions alloc] init];
//                fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//                fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d || mediaType = %d",PHAssetMediaTypeImage,PHAssetMediaTypeVideo];
//                
//                PHFetchResult<PHAsset *> *assets  = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
//                
//                if ([assets count] > 0) {
//                    albumName = collection.localizedTitle;
//                    *stop = YES;
//                }
//            }];
//            
//            BKIPImageAlbumListViewController * imageClassVC = [[BKIPImageAlbumListViewController alloc]init];
//            
//            BKIPImagePickerViewController * imageVC = [[BKIPImagePickerViewController alloc]init];
//            
//            imageClassVC.title = @"相册";
//            imageVC.title = albumName;
//            
//            self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:BKFinishSelectImageNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//                
//                if ([self.imageManageModel.selectImageArray count] == 1) {
//                    BKImageModel * model = [self.imageManageModel.selectImageArray firstObject];
//                    if (model.photoType != BKIPSelectTypeVideo) {
//                        if (complete) {
//                            if (self.imageManageModel.isOriginal) {
//                                complete([UIImage imageWithData:model.originalImageData], model.originalImageData, model.url, model.photoType);
//                            }else{
//                                complete([UIImage imageWithData:model.thumbImageData], model.thumbImageData, model.url, model.photoType);
//                            }
//                        }
//                    }else{
//                        if (complete) {
//                            complete([UIImage imageWithData:model.originalImageData], [NSData dataWithContentsOfURL:model.url], model.url, model.photoType);
//                        }
//                    }
//                }else{
//                    for (BKImageModel * model in self.imageManageModel.selectImageArray) {
//                        if (complete) {
//                            if (self.imageManageModel.isOriginal) {
//                                complete([UIImage imageWithData:model.originalImageData], model.originalImageData, model.url, model.photoType);
//                            }else{
//                                complete([UIImage imageWithData:model.thumbImageData], model.thumbImageData, model.url, model.photoType);
//                            }
//                        }
//                    }
//                }
//                
//                [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
//            }];
//            
//            BKNavigationController * nav = [[BKNavigationController alloc]initWithRootViewController:imageClassVC];
//            [nav pushViewController:imageVC animated:NO];
//            nav.popVC = imageClassVC;
//            [lastVC presentViewController:nav animated:YES completion:nil];
//        }
//    } alertHandler:nil];
}

@end
