//
//  BKImagePickerMacro.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#ifndef BKImagePickerMacro_h
#define BKImagePickerMacro_h

/********************************** 通用颜色 **********************************/

//导航背景颜色
#define BKIP_NAV_BG_COLOR BKIP_HEX_RGBA(0xFFFFFF, 0.8)
//导航标题颜色
#define BKIP_NAV_TITLE_COLOR [UIColor blackColor]
//导航按钮标题颜色
#define BKIP_NAV_BTN_TITLE_COLOR BKIP_HEX_RGB(0x2D96FA)
//所有线的颜色
#define BKIP_LINE_COLOR BKIP_HEX_RGB(0xE4E4E4)

/********************************** 相簿界面、修改图片界面 **********************************/

//相册列表 相册名称颜色
#define BKIP_AlbumList_AlbumTitleColor [UIColor blackColor]
//相册列表 相片数量颜色
#define BKIP_AlbumList_ImageCountColor [UIColor colorWithWhite:0.5 alpha:1]
//相片列表 (未选中)发送图片按钮标题颜色
#define BKIP_ImagePicker_SendTitleNormalColor [UIColor colorWithWhite:0.5 alpha:1]
//相片列表 (有选中)发送图片按钮标题颜色
#define BKIP_ImagePicker_SendTitleHighlightedColor [UIColor whiteColor]
//相片列表 (未选中)发送图片按钮背景颜色
#define BKIP_ImagePicker_SendNormalBackgroundColor [UIColor colorWithWhite:0.8 alpha:1]
//相片列表 (有选中)发送图片按钮背景颜色
#define BKIP_ImagePicker_SendHighlightedBackgroundColor BK_HEX_RGB(0x2D96FA)
//相片列表 列表底部图片数量标注颜色
#define BKIP_ImagePicker_ImageNumberTitleColor [UIColor colorWithWhite:0.5 alpha:1]
//相片列表 视频时长颜色
#define BKIP_ImagePicker_VideoTimeTitleColor [UIColor whiteColor]
//相片列表 GIF、视频标注阴影颜色
#define BKIP_ImagePicker_VideoShadowColor [UIColor blackColor]
//相片列表 GIF、视频标注颜色
#define BKIP_ImagePicker_VideoMarkColor [UIColor whiteColor]
//相片列表 (未选中)选中图片按钮背景颜色
#define BKIP_ImagePicker_SelectImageNumberNormalBackgroundColor [UIColor colorWithWhite:0.2 alpha:0.5]
//相片列表 (选中)选中图片按钮背景颜色
#define BKIP_ImagePicker_SelectImageNumberHighlightedBackgroundColor BK_HEX_RGB(0x2D96FA)
//相片列表 选中图片按钮边框线颜色
#define BKIP_ImagePicker_SelectImageNumberBorderColor [UIColor whiteColor]
//相片列表 选中图片数量颜色
#define BKIP_ImagePicker_SelectImageNumberTitleColor [UIColor whiteColor]
//相片列表 底部原图对勾颜色
#define BKIP_ImagePicker_OriginalImageHookColor [UIColor whiteColor]
//视频预览 背景颜色
#define BKIP_VideoPreview_BackgroundColor [UIColor blackColor]
//视频预览 底部导航背景颜色
#define BKIP_VideoPreview_BottomNavBackgroundColor [UIColor colorWithWhite:0.2 alpha:0.5]
//视频预览 底部文字颜色(取消、选取)
#define BKIP_VideoPreview_BottomNavTitleColor [UIColor whiteColor]
//编辑图片 背景颜色
#define BKIP_EditImage_BackgroundColor [UIColor blackColor]
//编辑图片 多张图编辑时选中框的颜色
#define BKIP_EditImage_SelectImageFrameColor BK_HEX_RGB(0x2D96FA)
//编辑图片 底部按钮的颜色(取消,确认)
#define BKIP_EditImage_BottomBtnBackgroundColor BK_HEX_RGB(0x2D96FA)
//编辑图片 编辑栏中字的颜色
#define BKIP_EditImage_BottomTitleColor [UIColor whiteColor]
//编辑图片 编辑文字输入框背景颜色
#define BKIP_EditImage_TextViewBackgroundColor BKNavBackgroundColor
//编辑图片 (文字未拖入)删除输入文字按钮背景颜色
#define BKIP_EditImage_DeleteWriteNormalBackgroundColor BK_HEX_RGB(0x2D96FA)
//编辑图片 (文字已拖入)删除输入文字按钮背景颜色
#define BKIP_EditImage_DeleteWriteHighlightedBackgroundColor BK_HEX_RGB(0xff725c)
//编辑图片 拖动输入文字四周的框
#define BKIP_EditImage_TextFrameColor BK_HEX_RGB(0x2D96FA)
//编辑图片 裁剪四周阴影的颜色
#define BKIP_EditImage_ClipShadowBackgroundColor [UIColor colorWithWhite:0 alpha:0.6]
//编辑图片 裁剪框的颜色
#define BKIP_EditImage_ClipFrameColor [UIColor whiteColor]

/********************************** 常用宏定义 **********************************/

#define BKIP_RGB(R, G, B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0]
#define BKIP_RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define BKIP_HEX_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BKIP_HEX_RGBA(rgbValue, A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]

#define BKIP_SCREENW [UIScreen mainScreen].bounds.size.width
#define BKIP_SCREENH [UIScreen mainScreen].bounds.size.height

#define BKIP_POINTS_FROM_PIXELS(__PIXELS) (__PIXELS / [[UIScreen mainScreen] scale])
#define BKIP_ONE_PIXEL BKIP_POINTS_FROM_PIXELS(1.0)

#define BKIP_WEAK_SELF(obj) __weak typeof(obj) weakSelf = obj;
#define BKIP_STRONG_SELF(obj) __strong typeof(obj) strongSelf = weakSelf;

#endif /* BKImagePickerMacro_h */
