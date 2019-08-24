//
//  BKImagePickerShareManager.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePickerShareManager.h"
#import "BKImagePickerHeader.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface BKImagePickerShareManager()

@property (nonatomic,strong) PHCachingImageManager * cachingImageManager;//图片缓存管理者

@end

@implementation BKImagePickerShareManager

#pragma mark - 单例

static BKImagePickerShareManager * sharedManager = nil;
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

#pragma mark - 通用属性

-(BKImagePickerModel *)imagePickerModel
{
    if (!_imagePickerModel) {
        _imagePickerModel = [[BKImagePickerModel alloc] init];
    }
    return _imagePickerModel;
}

#pragma mark - 提示

-(UIAlertController*)presentAlert:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (NSString * title in actionTitleArr) {
        
        NSInteger style;
        if ([title isEqualToString:@"取消"]) {
            style = UIAlertActionStyleCancel;
        }else{
            style = UIAlertActionStyleDefault;
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (actionMethod) {
                actionMethod([actionTitleArr indexOfObject:title]);
            }
        }];
        [alert addAction:action];
    }
    [self.bk_displayViewController presentViewController:alert animated:YES completion:nil];
    return alert;
}

-(UIAlertController*)presentActionSheet:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString * title in actionTitleArr) {
        
        NSInteger style;
        if ([title isEqualToString:@"取消"]) {
            style = UIAlertActionStyleCancel;
        }else{
            style = UIAlertActionStyleDefault;
        }
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (actionMethod) {
                actionMethod([actionTitleArr indexOfObject:title]);
            }
        }];
        [alert addAction:action];
    }
    [self.bk_displayViewController presentViewController:alert animated:YES completion:nil];
    return alert;
}

#pragma mark - 检测私有属性

/**
 检测是否允许调用相册
 */
-(void)checkAllowVisitPhotoAlbumHandler:(void (^)(BOOL flag))handler alertHandler:(void (^)(void))alertHandler
{
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        if (handler) {
                            handler(YES);
                        }
                    }else{
                        if (handler) {
                            handler(NO);
                        }
                        [self presentAlert:@"提示" message:[NSString stringWithFormat:@"%@没有权限访问您的相册\n在“设置-隐私-照片”中开启即可查看",app_Name] actionTitleArr:@[@"确认",@"去设置"] actionMethod:^(NSInteger index) {
                            if (index == 1) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            }
                            if (alertHandler) {
                                alertHandler();
                            }
                        }];
                    }
                });
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        {
            if (handler) {
                handler(NO);
            }
            
            [self presentAlert:@"提示" message:[NSString stringWithFormat:@"%@没有访问相册的权限",app_Name] actionTitleArr:@[@"确认"] actionMethod:^(NSInteger index) {
                if (alertHandler) {
                    alertHandler();
                }
            }];
        }
            break;
        case PHAuthorizationStatusDenied:
        {
            if (handler) {
                handler(NO);
            }
            
            [self presentAlert:@"提示" message:[NSString stringWithFormat:@"%@没有权限访问您的相册\n在“设置-隐私-照片”中开启即可查看",app_Name] actionTitleArr:@[@"确认",@"去设置"] actionMethod:^(NSInteger index) {
                if (index == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
                if (alertHandler) {
                    alertHandler();
                }
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(YES);
                }
            });
        }
            break;
        default:
            break;
    }
}

#pragma mark - 获取图片

-(PHCachingImageManager*)cachingImageManager
{
    if (!_cachingImageManager) {
        _cachingImageManager = [[PHCachingImageManager alloc] init];
    }
    return _cachingImageManager;
}

/**
 获取对应缩略图
 
 @param asset 相片
 @param complete 完成方法
 */
-(void)getThumbImageWithAsset:(PHAsset*)asset complete:(void (^)(UIImage * thumbImage))complete
{
    PHImageRequestOptions * thumbImageOptions = [[PHImageRequestOptions alloc] init];
    thumbImageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    thumbImageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    thumbImageOptions.synchronous = NO;
    thumbImageOptions.networkAccessAllowed = YES;
    
    [self.cachingImageManager requestImageForAsset:asset targetSize:CGSizeMake(BKIP_SCREENW/2.0f, BKIP_SCREENW/2.0f) contentMode:PHImageContentModeAspectFill options:thumbImageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(result);
            }
        });
    }];
}

/**
 获取对应原图
 
 @param asset 相片
 @param complete 完成方法
 */
-(void)getOriginalImageWithAsset:(PHAsset*)asset complete:(void (^)(UIImage * originalImage))complete
{
    PHImageRequestOptions * originalImageOptions = [[PHImageRequestOptions alloc] init];
    originalImageOptions.version = PHImageRequestOptionsVersionOriginal;
    originalImageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    originalImageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    originalImageOptions.synchronous = NO;
    originalImageOptions.networkAccessAllowed = YES;
    
    [self.cachingImageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:originalImageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        // 排除取消，错误，低清图三种情况，即已经获取到了高清图
        BOOL downImageloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downImageloadFinined) {
            if(result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (complete) {
                        complete(result);
                    }
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete) {
                    complete(nil);
                }
            });
        }
    }];
}

/**
 获取对应原图data
 
 @param asset 相片
 @param progressHandler 下载进度返回
 @param complete 完成方法
 */
-(void)getOriginalImageDataWithAsset:(PHAsset*)asset progressHandler:(void (^)(double progress, NSError * error, PHImageRequestID imageRequestID))progressHandler complete:(void (^)(NSData * originalImageData, NSURL * url, PHImageRequestID imageRequestID))complete
{
    PHImageRequestOptions * originalImageOptions = [[PHImageRequestOptions alloc] init];
    originalImageOptions.version = PHImageRequestOptionsVersionOriginal;
    originalImageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    originalImageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    originalImageOptions.synchronous = NO;
    originalImageOptions.networkAccessAllowed = YES;
    [originalImageOptions setProgressHandler:^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PHImageRequestID imageRequestID = [info[PHImageResultRequestIDKey] intValue];
            if (progressHandler) {
                progressHandler(progress, error, imageRequestID);
            }
        });
    }];
    
    __block PHImageRequestID imageRequestID = [self.cachingImageManager requestImageDataForAsset:asset options:originalImageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        NSURL * url = info[@"PHImageFileURLKey"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(imageData, url, imageRequestID);
            }
        });
    }];
}

#pragma mark - 压缩图片

/**
 压缩图片
 
 @param imageData 原图data
 @return 缩略图data
 */
-(NSData *)compressImageData:(NSData *)imageData
{
    if (!imageData) {
        return nil;
    }
    
    NSData * newImageData = [self compressImageWithData:imageData];
    return newImageData;
}

-(NSData *)compressImageWithData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    //创建 CGImageSourceRef
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data,
                                                               (__bridge CFDictionaryRef)@{(NSString *)kCGImageSourceShouldCache: @NO});
    if (!imageSource) {
        return nil;
    }
    
    CFStringRef imageSourceContainerType = CGImageSourceGetType(imageSource);
    //检测是否是GIF
    BOOL isGIFData = UTTypeConformsTo(imageSourceContainerType, kUTTypeGIF);
    //检测是否是PNG
    BOOL isPNGData = UTTypeConformsTo(imageSourceContainerType, kUTTypePNG);
    
    //图片数量
    size_t imageCount = CGImageSourceGetCount(imageSource);
    //保存图片地址
    NSString * saveImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%.0f.%@",[[NSDate date] timeIntervalSince1970],(isGIFData?@"gif":(isPNGData?@"png":@"jpg"))]];
    //创建图片写入
    CGImageDestinationRef destinationRef = CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:saveImagePath], isGIFData?kUTTypeGIF:(isPNGData?kUTTypePNG:kUTTypeJPEG), imageCount, NULL);
    //获取原图片属性
    NSDictionary * imageProperties = (__bridge NSDictionary *) CGImageSourceCopyProperties(imageSource, NULL);
    
    //遍历图片所有帧
    for (size_t i = 0; i < (isGIFData?imageCount:1); i++) {
        @autoreleasepool {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            if (imageRef) {
                //获取某一帧图片属性
                NSDictionary * frameProperties =
                (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageSource, i, NULL);
                
                CGImageRef compressImageRef = [self compressImageRef:imageRef];
                //写入图片
                CGImageDestinationAddImage(destinationRef, compressImageRef, (CFDictionaryRef)frameProperties);
                //写入图片属性
                CGImageDestinationSetProperties(destinationRef, (CFDictionaryRef)imageProperties);
                
                CGImageRelease(compressImageRef);
            }
            
            CGImageRelease(imageRef);
        }
    }
    //结束图片写入
    CGImageDestinationFinalize(destinationRef);
    
    CFRelease(destinationRef);
    CFRelease(imageSource);
    
    NSData * animatedImageData = [NSData dataWithContentsOfFile:saveImagePath];
    
    return animatedImageData;
}

//YYImage压缩图片方法
-(CGImageRef)compressImageRef:(CGImageRef)imageRef
{
    if (!imageRef) {
        return nil;
    }
    
    size_t width = floor(CGImageGetWidth(imageRef) * BKThumbImageCompressSizeMultiplier);
    size_t height = floor(CGImageGetHeight(imageRef) * BKThumbImageCompressSizeMultiplier);
    if (width == 0 || height == 0) {
        return nil;
    }
    
    CGFloat target_max_width = BKIP_SCREENW * [UIScreen mainScreen].scale;
    if (width > target_max_width) {
        height = target_max_width / width * height;
        width = target_max_width;
    }
    
    BOOL hasAlpha = [self checkHaveAlphaWithImageRef:imageRef];
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
    if (!context) {
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    CFRelease(context);
    
    return newImageRef;
}

#pragma mark - 查看图片是否含有alpha

/**
 查看图片是否含有alpha
 
 @param imageRef imageRef
 @return 结果
 */
-(BOOL)checkHaveAlphaWithImageRef:(CGImageRef)imageRef
{
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
    
    BOOL hasAlpha = NO;
    if (alphaInfo == kCGImageAlphaPremultipliedLast ||
        alphaInfo == kCGImageAlphaPremultipliedFirst ||
        alphaInfo == kCGImageAlphaLast ||
        alphaInfo == kCGImageAlphaFirst) {
        hasAlpha = YES;
    }
    
    return hasAlpha;
}

#pragma mark - 保存图片

/**
 保存图片
 */
-(void)saveImage:(UIImage*)image complete:(void (^)(PHAsset * asset, BOOL success))complete
{
    [self checkAllowVisitPhotoAlbumHandler:^(BOOL flag) {
        if (flag) {
            __block NSString *assetId = nil;
            //存储图片到"相机胶卷"
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (complete) {
                            complete(nil, success);
                        }
                    });
                    return;
                }
                
                //把相机胶卷图片保存到自己创建的相册中
                //图片
                PHAsset * asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
                //自己的相册
                PHAssetCollection *collection = [self collection];
                //转移
                [self asset:asset transferToCsCollection:collection complete:^(PHAsset *asset, BOOL success) {
                    if (complete) {
                        complete(asset, success);
                    }
                }];
            }];
        }
    } alertHandler:^{
        
    }];
}

/**
 把资源转移到特定的相册中
 */
-(void)asset:(PHAsset *)asset transferToCsCollection:(PHAssetCollection *)collection complete:(void (^)(PHAsset * asset, BOOL success))complete
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest * request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        [request addAssets:@[asset]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(asset, success);
            }
        });
    }];
}

/**
 获取保存图片、视频相册
 */
-(PHAssetCollection *)collection
{
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    // 先获得之前创建过的相册
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:app_Name]) {
            return collection;
        }
    }
    
    // 如果相册不存在,就创建新的相册(文件夹)
    __block NSString *collectionId = nil; // __block修改block外部的变量的值
    // 这个方法会在相册创建完毕后才会返回
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 新建一个PHAssertCollectionChangeRequest对象, 用来创建一个新的相册
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:app_Name].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
}

@end
