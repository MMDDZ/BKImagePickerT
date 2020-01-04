//
//  BKImagePickerConstant.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - 通知

UIKIT_EXTERN NSString * const kBKIPFinishSelectImageNotification;//选择完成通知

#pragma mark - 常量

UIKIT_EXTERN const float kBKIPTopNavLeftRightOffset;//上部导航按钮对边界的距离
UIKIT_EXTERN const float kBKIPTopNavBtnImageInsets;//上部导航按钮图片内边距 只有图片时 如果self.bk_width < _imageSize.width + kBKIPTopNavBtnImageInsets*2 时有效 否则无效
UIKIT_EXTERN const float kBKIPTopNavBtnTitleInsets;//上部导航按钮文本内边距

UIKIT_EXTERN const float BKAlbumImagesSpacing;//相簿图片间距
UIKIT_EXTERN const float BKExampleImagesSpacing;//查看的大图图片间距
UIKIT_EXTERN const float BKCheckExampleImageAnimateTime;//查看大图图片过场动画时间
UIKIT_EXTERN const float BKCheckExampleGifAndVideoAnimateTime;//查看Gif、Video过场动画时间
UIKIT_EXTERN const float BKThumbImageCompressSizeMultiplier;//图片长宽压缩比例 (小于1会把图片的长宽缩小)

UIKIT_EXTERN NSString * const BKCanNotSelectBothTheImageAndVideoRemind;//不能同时选择照片和视频
UIKIT_EXTERN NSString * const BKPleaseSelectImageRemind;//请选择图片
UIKIT_EXTERN NSString * const BKOriginalImageDownloadFailedRemind;//原图下载失败
UIKIT_EXTERN NSString * const BKSelectImageDownloadingRemind;//选中的图片正在加载中,请稍后再试
UIKIT_EXTERN NSString * const BKImageSavedSuccessRemind;//图片保存成功
UIKIT_EXTERN NSString * const BKImageSaveFailedRemind;//图片保存失败

UIKIT_EXTERN NSString * const BKSelectVideoDownloadingRemind;//视频正在加载中,请稍后再试
UIKIT_EXTERN NSString * const BKVideoDownloadFailedRemind;//视频下载失败
UIKIT_EXTERN NSString * const BKVideoCoverDownloadFailedRemind;//封面下载失败

