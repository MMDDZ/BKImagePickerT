//
//  UIView+BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BKImagePicker)

#pragma mark - 附加属性

/**
 x
 */
@property (nonatomic, assign) CGFloat bk_x;
/**
 y
 */
@property (nonatomic, assign) CGFloat bk_y;
/**
 width
 */
@property (nonatomic, assign) CGFloat bk_width;
/**
 height
 */
@property (nonatomic, assign) CGFloat bk_height;
/**
 origin
 */
@property (nonatomic, assign) CGPoint bk_origin;
/**
 size
 */
@property (nonatomic, assign) CGSize bk_size;
/**
 centerX
 */
@property (nonatomic, assign) CGFloat bk_centerX;
/**
 centerY
 */
@property (nonatomic, assign) CGFloat bk_centerY;

#pragma mark - Loading

/**
 查找view中是否存在loadLayer
 
 @return loadLayer
 */
-(CALayer*)bk_findLoadLayer;

/**
 加载Loading
 
 @return loadLayer
 */
-(CALayer*)bk_showLoadLayer;

/**
 加载Loading 带下载进度
 
 @param progress 进度
 */
-(void)bk_showLoadLayerWithDownLoadProgress:(CGFloat)progress;

/**
 隐藏Loading
 */
-(void)bk_hideLoadLayer;

@end

NS_ASSUME_NONNULL_END
