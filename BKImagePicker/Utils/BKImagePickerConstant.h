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


#pragma mark - 常量

UIKIT_EXTERN const float kBKIPTopNavLeftRightOffset;//上部导航按钮对边界的距离
UIKIT_EXTERN const float kBKIPTopNavBtnImageInsets;//上部导航按钮图片内边距 只有图片时 如果self.bk_width < _imageSize.width + kBKIPTopNavBtnImageInsets*2 时有效 否则无效
UIKIT_EXTERN const float kBKIPTopNavBtnTitleInsets;//上部导航按钮文本内边距

UIKIT_EXTERN const float BKThumbImageCompressSizeMultiplier;//图片长宽压缩比例 (0~1 会把图片的长宽缩小)

