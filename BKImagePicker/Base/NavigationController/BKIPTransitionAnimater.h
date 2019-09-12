//
//  BKIPTransitionAnimater.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/26.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BKIPTransitionAnimaterDirection) {//进入时过场动画的方向
    BKIPTransitionAnimaterDirectionRight = 0,
    BKIPTransitionAnimaterDirectionLeft
};

typedef NS_ENUM(NSUInteger, BKIPTransitionAnimaterType) {
    BKIPTransitionAnimaterTypePush = 0,
    BKIPTransitionAnimaterTypePop
};

NS_ASSUME_NONNULL_BEGIN

@interface BKIPTransitionAnimater : NSObject <UIViewControllerAnimatedTransitioning>

#pragma mark - 属性

/**
 是否是手势返回
 */
@property (nonatomic, assign) BOOL interation;

#pragma mark - 回调

/**
 返回成功回调
 */
@property (nonatomic,copy) void (^finishBackCallBack)(void);

#pragma mark - 创建方法

/**
 创建方法
 
 @param type 过场动画的方法
 @param direction 过场动画的方向
 @return BKIPTransitionAnimater
 */
- (instancetype)initWithTransitionType:(BKIPTransitionAnimaterType)type transitionAnimaterDirection:(BKIPTransitionAnimaterDirection)direction;


@end

NS_ASSUME_NONNULL_END
