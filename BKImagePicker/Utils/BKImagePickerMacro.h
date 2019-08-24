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
