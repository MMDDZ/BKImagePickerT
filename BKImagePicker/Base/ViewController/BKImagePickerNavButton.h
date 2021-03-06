//
//  BKImagePickerNavButton.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 当图片和标题同时存在时 图片相对于标题的位置
 
 - BKIPImagePositionLeft: 左边
 - BKIPImagePositionTop: 上边
 - BKIPImagePositionRight: 右边
 - BKIPImagePositionBottom: 下边
 */
typedef NS_ENUM(NSUInteger, BKIPImagePosition) {
    BKIPImagePositionLeft = 0,
    BKIPImagePositionTop,
    BKIPImagePositionRight,
    BKIPImagePositionBottom,
};

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePickerNavButton : UIControl

/***************************************************************************************************
 默认frame = CGRectMake(自动排列间距0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())
 ***************************************************************************************************/

#pragma mark - 图片init

-(nonnull instancetype)initWithImage:(nonnull UIImage *)image;
-(nonnull instancetype)initWithImage:(nonnull UIImage *)image imageSize:(CGSize)imageSize;

#pragma mark - 标题init

-(nonnull instancetype)initWithTitle:(nonnull NSString*)title;
-(nonnull instancetype)initWithTitle:(nonnull NSString*)title font:(nonnull UIFont*)font;
-(nonnull instancetype)initWithTitle:(nonnull NSString*)title titleColor:(nonnull UIColor*)titleColor;
-(nonnull instancetype)initWithTitle:(nonnull NSString*)title font:(nonnull UIFont*)font titleColor:(nonnull UIColor*)titleColor;

#pragma mark - 图片&标题init

-(nonnull instancetype)initWithImage:(nonnull UIImage *)image title:(nonnull NSString*)title;
-(nonnull instancetype)initWithImage:(nonnull UIImage *)image title:(nonnull NSString*)title imagePosition:(BKIPImagePosition)imagePosition;
-(nonnull instancetype)initWithImage:(nonnull UIImage *)image imageSize:(CGSize)imageSize title:(nonnull NSString*)title;
-(nonnull instancetype)initWithImage:(nonnull UIImage *)image imageSize:(CGSize)imageSize title:(nonnull NSString*)title imagePosition:(BKIPImagePosition)imagePosition;
-(nonnull instancetype)initWithImage:(nonnull UIImage *)image imageSize:(CGSize)imageSize title:(nonnull NSString*)title font:(nonnull UIFont*)font titleColor:(nonnull UIColor*)titleColor imagePosition:(BKIPImagePosition)imagePosition;

#pragma mark - 标题属性

/**
 标题
 */
@property (nonatomic,copy,nonnull) NSString * title;
/**
 标题大小
 */
@property (nonatomic,strong,nonnull) UIFont * font;
/**
 标题颜色
 */
@property (nonatomic,strong,nonnull) UIColor * titleColor;

#pragma mark - 图片属性

/**
 图片
 */
@property (nonatomic,strong,nonnull) UIImage * image;
/**
 图片大小
 */
@property (nonatomic,assign) CGSize imageSize;

/*
 图片颜色用tintColor修改
 */

/// 图片位置
@property (nonatomic,assign) BKIPImagePosition imagePosition;

@end

NS_ASSUME_NONNULL_END
