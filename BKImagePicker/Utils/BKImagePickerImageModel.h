//
//  BKImagePickerImageModel.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "BKImagePickerPEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePickerImageModel : NSObject

/**
 PHAsset
 */
@property (nonatomic,strong) PHAsset * asset;
/**
 图片名称
 */
@property (nonatomic,copy) NSString * fileName;
/**
 图片类型
 */
@property (nonatomic,assign) BKIPSelectType photoType;
/**
 缩略图
 */
@property (nonatomic,strong) UIImage * thumbImage;
/**
 缩略图data
 */
@property (nonatomic,strong) NSData * thumbImageData;
/**
 原图data (当photoType == BKIPSelectTypeVideo时 为封面图data)
 */
@property (nonatomic,strong) NSData * originalImageData;
/**
 加载的进度0~1 0代表未加载或者加载失败 1代表加载完成 其余代表加载中
 */
@property (nonatomic,assign) CGFloat loadingProgress;
/**
 原图大小
 */
@property (nonatomic,assign) double originalImageSize;
/**
 URL
 */
@property (nonatomic,strong) NSURL * url;

@end

NS_ASSUME_NONNULL_END
