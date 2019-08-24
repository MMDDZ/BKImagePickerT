//
//  BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "BKImagePickerPEnum.h"

FOUNDATION_EXPORT double BKImagePickerVersionNumber;
FOUNDATION_EXPORT const unsigned char BKImagePickerVersionString[];

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePicker : NSObject

#pragma mark - 单例

/**
 单例
 
 @return BKImagePicker
 */
+(instancetype)sharedManager;

#pragma mark - 相册

/**
 相册
 
 @param displayType 显示类型
 @param maxSelect 最大选择数 (最大999)
 @param isHaveOriginal 是否有原图选项 (没有原图选项即选取的图片都是缩略图)
 @param complete  asset图片/视频文件 image图片/视频封面图 data图片/视频封面图data url图片/视频文件路径 selectType选取的类型
 */
-(void)showImageAlbumWithDisplayType:(BKIPDisplayType)displayType maxSelect:(NSInteger)maxSelect isHaveOriginal:(BOOL)isHaveOriginal complete:(void (^)(PHAsset * asset, UIImage * image, NSData * data, NSURL * url, BKIPSelectType selectType))complete;

/**
 相册 + 裁剪

 @param displayType 显示类型 不能选择视频 GIF暂不支持
 @param aspectRatio 预定裁剪大小宽高比
 @param isHaveOriginal 是否有原图选项 (没有原图选项即选取的图片都是缩略图)
 @param complete asset图片文件 image图片 data图片data url图片文件路径 selectType选取的类型
 */
-(void)showImageAlbumWithDisplayType:(BKIPDisplayType)displayType aspectRatio:(CGFloat)aspectRatio isHaveOriginal:(BOOL)isHaveOriginal complete:(void (^)(PHAsset * asset, UIImage * image, NSData * data, NSURL * url, BKIPSelectType selectType))complete;

@end

NS_ASSUME_NONNULL_END
