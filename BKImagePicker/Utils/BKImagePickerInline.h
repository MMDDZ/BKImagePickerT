//
//  BKIPInline.h
//  BKIP
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#ifndef BKIPInline_h
#define BKIPInline_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/* 编译错误解决：implicit declaration of function 'close' is invalid in C99
 #import <sys/time.h>
 #import <fcntl.h>
 #import <unistd.h>
 */
#import <sys/time.h>
#import <fcntl.h>
#import <unistd.h>

#pragma mark - 检测是否是iPhoneX系列

/**
 判断是否是iPhone X系列
 */
NS_INLINE BOOL BKIP_is_iPhoneX_series() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

/**
 获取系统状态栏高度
 */
NS_INLINE CGFloat BKIP_get_system_statusBar_height() {
    return BKIP_is_iPhoneX_series() ? 44.f : 20.f;
}

/**
 获取系统导航高度
 */
NS_INLINE CGFloat BKIP_get_system_nav_height() {
    return BKIP_is_iPhoneX_series() ? (44.f+44.f) : 64.f;
}

/**
 获取系统导航UI高度
 */
NS_INLINE CGFloat BKIP_get_system_nav_ui_height() {
    return BKIP_get_system_nav_height() - BKIP_get_system_statusBar_height();
}

/**
 获取系统tabbar高度
 */
NS_INLINE CGFloat BKIP_get_system_tabbar_height() {
    return BKIP_is_iPhoneX_series() ? 83.f : 49.f;
}

/**
 获取系统tabbarUI高度
 */
NS_INLINE CGFloat BKIP_get_system_tabbar_ui_height() {
    return 49.f;
}

/**
 获取系统tabbarUI增加的高度 (因iPhoneX系列底部有安全区域增加的高度)
 */
NS_INLINE CGFloat BKIP_get_system_tabbar_ui_offsetHeight() {
    return BKIP_get_system_tabbar_height() - BKIP_get_system_tabbar_ui_height();
}

#pragma mark - 字体

/**
 细体
 */
UIKIT_STATIC_INLINE UIFont * BKIP_thin_font(CGFloat pointSize) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:pointSize weight:UIFontWeightThin];
    }else {
        return [UIFont systemFontOfSize:pointSize];
    }
}

/**
 半细体
 */
UIKIT_STATIC_INLINE UIFont * BKIP_light_font(CGFloat pointSize) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:pointSize weight:UIFontWeightLight];
    }else {
        return [UIFont systemFontOfSize:pointSize];
    }
}

/**
 正常体
 */
UIKIT_STATIC_INLINE UIFont * BKIP_regular_font(CGFloat pointSize) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:pointSize weight:UIFontWeightRegular];
    }else {
        return [UIFont systemFontOfSize:pointSize];
    }
}

/**
 半粗体
 */
UIKIT_STATIC_INLINE UIFont * BKIP_medium_font(CGFloat pointSize) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:pointSize weight:UIFontWeightMedium];
    }else {
        return [UIFont systemFontOfSize:pointSize];
    }
}

/**
 粗体
 */
UIKIT_STATIC_INLINE UIFont * BKIP_semibold_font(CGFloat pointSize) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:pointSize weight:UIFontWeightSemibold];
    }else {
        return [UIFont systemFontOfSize:pointSize];
    }
}

#pragma mark - 提示

UIKIT_STATIC_INLINE void BKIP_showMessage(NSString * message) {
    
    if ([message length] <= 0) {
        return;
    }
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
    bgView.layer.cornerRadius = 8.0f;
    bgView.clipsToBounds = YES;
    [window addSubview:bgView];
    
    UILabel * remindLab = [[UILabel alloc]init];
    remindLab.textColor = [UIColor whiteColor];
    CGFloat fontSize = 15.0 * window.bounds.size.width / 375.0f;
    UIFont * font = [UIFont systemFontOfSize:fontSize];
    remindLab.font = font;
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.numberOfLines = 0;
    remindLab.backgroundColor = [UIColor clearColor];
    remindLab.text = message;
    [bgView addSubview:remindLab];
    
    CGFloat width = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, window.bounds.size.height)
                                          options: NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil].size.width;
    if (width > window.bounds.size.width/4.0*3.0f) {
        width = window.bounds.size.width/4.0*3.0f;
    }
    CGFloat height = [message boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options: NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: font}
                                           context:nil].size.height;
    
    bgView.bounds = CGRectMake(0, 0, width + 20, height + 20);
    bgView.layer.position = CGPointMake(window.bounds.size.width / 2.0f, window.bounds.size.height / 2.0f);
    
    remindLab.bounds = CGRectMake(0, 0, width, height);
    remindLab.layer.position = CGPointMake(bgView.bounds.size.width / 2.0f, bgView.bounds.size.height / 2.0f);
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
    }];
}

#endif /* BKIPInline_h */
