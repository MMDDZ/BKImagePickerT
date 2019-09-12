//
//  UINavigationController+BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/26.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKIPTransitionAnimater.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (BKImagePicker)

/**
 过场动画方向
 */
@property (nonatomic,assign) BKIPTransitionAnimaterDirection direction;
/**
 返回手势是否可用
 */
@property (nonatomic,assign) BOOL popGestureRecognizerEnable;
/**
 当前VC返回过场动画指定VC
 */
@property (nonatomic,strong) UIViewController * popVC;

@end

NS_ASSUME_NONNULL_END
