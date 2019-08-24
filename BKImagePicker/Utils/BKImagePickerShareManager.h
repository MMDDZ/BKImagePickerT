//
//  BKImagePickerShareManager.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "BKImagePickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePickerShareManager : NSObject

#pragma mark - 属性

/**
 通用属性
 */
@property (nonatomic,strong) BKImagePickerModel * imagePickerModel;

#pragma mark - 单例

/**
 单例
 
 @return BKImagePicker
 */
+(instancetype)sharedManager;

#pragma mark - 提示

-(UIAlertController*)presentAlert:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod;

-(UIAlertController*)presentActionSheet:(NSString*)title message:(NSString*)message actionTitleArr:(NSArray*)actionTitleArr actionMethod:(void (^)(NSInteger index))actionMethod;

#pragma mark - 检测私有属性

/**
 检测是否允许调用相册
 */
-(void)checkAllowVisitPhotoAlbumHandler:(void (^)(BOOL flag))handler alertHandler:(void (^)(void))alertHandler;

#pragma mark - 获取图片

/**
 获取对应缩略图
 
 @param asset 相片
 @param complete 完成方法
 */
-(void)getThumbImageWithAsset:(PHAsset*)asset complete:(void (^)(UIImage * thumbImage))complete;

/**
 获取对应原图
 
 @param asset 相片
 @param complete 完成方法
 */
-(void)getOriginalImageWithAsset:(PHAsset*)asset complete:(void (^)(UIImage * originalImage))complete;

/**
 获取对应原图data
 
 @param asset 相片
 @param progressHandler 下载进度返回
 @param complete 完成方法
 */
-(void)getOriginalImageDataWithAsset:(PHAsset*)asset progressHandler:(void (^)(double progress, NSError * error, PHImageRequestID imageRequestID))progressHandler complete:(void (^)(NSData * originalImageData, NSURL * url, PHImageRequestID imageRequestID))complete;

/**
 获取视频
 
 @param asset 相片
 @param progressHandler 下载进度返回
 @param complete 完成方法
 */
-(void)getVideoDataWithAsset:(PHAsset*)asset progressHandler:(void (^)(double progress, NSError * error, PHImageRequestID imageRequestID))progressHandler complete:(void (^)(AVPlayerItem * playerItem, PHImageRequestID imageRequestID))complete;

#pragma mark - 压缩图片

/**
 压缩图片
 
 @param imageData 原图data
 @return 缩略图data
 */
-(NSData *)compressImageData:(NSData *)imageData;

#pragma mark - 查看图片是否含有alpha

/**
 查看图片是否含有alpha
 
 @param imageRef imageRef
 @return 结果
 */
-(BOOL)checkHaveAlphaWithImageRef:(CGImageRef)imageRef;

#pragma mark - 保存图片

/**
 保存图片
 
 @param image 图片
 @param complete 保存完成方法
 */
-(void)saveImage:(UIImage*)image complete:(void (^)(PHAsset * asset, BOOL success))complete;

@end

NS_ASSUME_NONNULL_END
