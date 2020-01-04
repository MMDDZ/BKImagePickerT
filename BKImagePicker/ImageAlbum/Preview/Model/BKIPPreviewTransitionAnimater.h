//
//  BKIPPreviewTransitionAnimater.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/12/30.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BKShowExampleTransition) {
    BKShowExampleTransitionPush = 0,
    BKShowExampleTransitionPop,
};

NS_ASSUME_NONNULL_BEGIN

@interface BKIPPreviewTransitionAnimater : NSObject<UIViewControllerAnimatedTransitioning>

/**
 返回时背景透明百分比
 */
@property (nonatomic,assign) CGFloat alphaPercentage;
/**
 起始imageView
 */
@property (nonatomic,strong) UIImageView * startImageView;
/**
 结束点frame
 */
@property (nonatomic,assign) CGRect endRect;
/**
 转场动画完成回调
 */
@property (nonatomic,copy) void (^endTransitionAnimateAction)(void);

- (instancetype)initWithTransitionType:(BKShowExampleTransition)type;

@end

NS_ASSUME_NONNULL_END
