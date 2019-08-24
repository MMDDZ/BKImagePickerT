//
//  BKImagePickerBaseViewController.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BKImagePickerNavButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePickerBaseViewController : UIViewController

#pragma mark - 顶部导航

@property (nonatomic,strong) UIView * topNavView;//高度为 BKIP_get_system_nav_height()
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong,nullable) NSArray<BKImagePickerNavButton*> * leftNavBtns;
@property (nonatomic,strong,nullable) NSArray<BKImagePickerNavButton*> * rightNavBtns;
@property (nonatomic,strong) UIImageView * topLine;
@property (nonatomic,assign) CGFloat topNavViewHeight;//topNavView的高度 默认高度为 BKIP_get_system_nav_height()

/**
 添加左边返回按钮(特殊情况时使用)
 */
-(void)addLeftBackNavBtn;

#pragma mark - 底部导航

@property (nonatomic,strong) UIView * bottomNavView;//高度为 0
@property (nonatomic,strong) UIImageView * bottomLine;
@property (nonatomic,assign) CGFloat bottomNavViewHeight;//bottomNavView的高度 默认高度为 0

#pragma mark - 状态栏

@property (nonatomic,assign) UIStatusBarStyle statusBarStyle;//状态栏样式
@property (nonatomic,assign) BOOL statusBarHidden;//状态栏是否隐藏
@property (nonatomic,assign) UIStatusBarAnimation statusBarUpdateAnimation;//状态栏更新动画

/**
 状态栏是否隐藏(带动画)
 
 @param hidden 是否隐藏
 @param animation 动画类型
 */
-(void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;

@end

NS_ASSUME_NONNULL_END
