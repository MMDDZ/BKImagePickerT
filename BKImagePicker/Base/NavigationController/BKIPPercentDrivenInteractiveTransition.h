//
//  BKIPPercentDrivenInteractiveTransition.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/26.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BKIPPercentDrivenInteractiveTransitionGestureDirection) {//手势的方向
    BKIPPercentDrivenInteractiveTransitionGestureDirectionRight = 0,
    BKIPPercentDrivenInteractiveTransitionGestureDirectionLeft
};

NS_ASSUME_NONNULL_BEGIN

@interface BKIPPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

#pragma mark - 属性

/**
 返回手势是否可用
 */
@property (nonatomic,assign) BOOL enble;
/**
 是否是手势返回
 */
@property (nonatomic, assign) BOOL interation;
/**
 返回的VC
 */
@property (nonatomic,weak) UIViewController * backVC;

#pragma mark - 方法

/**
 创建方法
 
 @param direction 手势的方向
 @return DSPercentDrivenInteractiveTransition
 */
-(instancetype)initWithTransitionGestureDirection:(BKIPPercentDrivenInteractiveTransitionGestureDirection)direction;

/**
 给传入的控制器添加手势
 
 @param viewController 控制器
 */
-(void)addPanGestureForViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
