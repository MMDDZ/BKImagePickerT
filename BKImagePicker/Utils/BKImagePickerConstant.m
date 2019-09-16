//
//  BKImagePickerConstant.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 通知

NSString * const kBKIPFinishSelectImageNotification = @"kBKIPFinishSelectImageNotification";//选择完成通知

#pragma mark - 常量

float const kBKIPTopNavLeftRightOffset = 6;
float const kBKIPTopNavBtnImageInsets = 4;
float const kBKIPTopNavBtnTitleInsets = 8;

float const BKAlbumImagesSpacing = 1;//相簿图片间距
float const BKExampleImagesSpacing = 10;//查看的大图图片间距
float const BKCheckExampleImageAnimateTime = 0.5;//查看大图图片过场动画时间
float const BKCheckExampleGifAndVideoAnimateTime = 0.3;//查看Gif、Video过场动画时间
float const BKThumbImageCompressSizeMultiplier = 0.5;//图片长宽压缩比例 (小于1会把图片的长宽缩小)
