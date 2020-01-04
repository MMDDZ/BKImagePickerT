//
//  BKIPPreviewInteractiveTransition.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/12/30.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKIPPreviewViewController.h"
#import "BKIPImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKIPPreviewInteractiveTransition : UIPercentDrivenInteractiveTransition

/**
 导航是否隐藏
 */
@property (nonatomic,assign) BOOL isNavHidden;
/**
 是否是手势返回
 */
@property (nonatomic, assign) BOOL interation;
/**
 起始imageView
 */
@property (nonatomic,strong) BKIPImageView * startImageView;
/**
 起始imageView父视图UIScrollView
 */
@property (nonatomic,strong) UIScrollView * supperScrollView;

/**
 添加手势
 
 @param viewController 控制器
 */
-(void)addPanGestureForViewController:(BKIPPreviewViewController *)viewController;
/**
 获取当前显示view的透明百分比
 
 @return 透明百分比
 */
-(CGFloat)getCurrentViewAlphaPercentage;

@end

NS_ASSUME_NONNULL_END
