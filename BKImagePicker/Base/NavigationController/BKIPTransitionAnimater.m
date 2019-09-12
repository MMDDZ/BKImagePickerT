//
//  BKIPTransitionAnimater.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/26.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPTransitionAnimater.h"
#import "BKImagePickerHeader.h"

@interface BKIPTransitionAnimater()

@property (nonatomic,assign) BKIPTransitionAnimaterType type;
@property (nonatomic,assign) BKIPTransitionAnimaterDirection direction;

@property (nonatomic,strong) UIView * fromShadowView;
@property (nonatomic,strong) UIView * toShadowView;

@end

@implementation BKIPTransitionAnimater

#pragma mark - 创建方法

-(instancetype)initWithTransitionType:(BKIPTransitionAnimaterType)type transitionAnimaterDirection:(BKIPTransitionAnimaterDirection)direction
{
    self = [super init];
    if (self) {
        _type = type;
        _direction = direction;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

-(NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    if (@available(iOS 11.0, *)) {
        if (_interation) {
            return 0.5;
        }else{
            return 0.25;
        }
    } else {
        return 0.25;
    }
}

-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case BKIPTransitionAnimaterTypePush:
        {
            [self nextAnimation:transitionContext];
        }
            break;
        case BKIPTransitionAnimaterTypePop:
        {
            [self backAnimation:transitionContext];
        }
            break;
    }
}

#pragma mark - 下一页

-(void)nextAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if (self.direction == BKIPTransitionAnimaterDirectionRight) {
        toVC.view.bk_x = BKIP_SCREENW;
    }else {
        toVC.view.bk_x = -BKIP_SCREENW;
    }

    UIView * containerView = [transitionContext containerView];
    [containerView addSubview:fromVC.view];

    if (!_fromShadowView) {
        _fromShadowView = [[UIView alloc]initWithFrame:fromVC.view.frame];
        _fromShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        _fromShadowView.alpha = 0;
        [containerView addSubview:_fromShadowView];
    }

    if (!_toShadowView) {
        _toShadowView = [[UIView alloc]initWithFrame:toVC.view.frame];
        _toShadowView.backgroundColor = [UIColor whiteColor];
        _toShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _toShadowView.layer.shadowOpacity = 0.45;
        _toShadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _toShadowView.layer.shadowRadius = 7;
        _toShadowView.alpha = 0;
        [containerView addSubview:_toShadowView];
    }

    [containerView addSubview:toVC.view];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{

        if (self.direction == BKIPTransitionAnimaterDirectionRight) {
            fromVC.view.bk_x = -BKIP_SCREENW/2;
            self.fromShadowView.bk_x = -BKIP_SCREENW/2;
        }else {
            fromVC.view.bk_x = BKIP_SCREENW/2;
            self.fromShadowView.bk_x = BKIP_SCREENW/2;
        }
        self.fromShadowView.alpha = 1;
        toVC.view.bk_x = 0;
        self.toShadowView.bk_x = 0;
        self.toShadowView.alpha = 1;

    } completion:^(BOOL finished) {

        [self.fromShadowView removeFromSuperview];
        self.fromShadowView = nil;
        [self.toShadowView removeFromSuperview];
        self.toShadowView = nil;

        [fromVC.view removeFromSuperview];

        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - 上一页

-(void)backAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView * containerView = [transitionContext containerView];
    
    if (self.direction == BKIPTransitionAnimaterDirectionRight) {
        toVC.view.bk_x = -BKIP_SCREENW/2;
    }else {
        toVC.view.bk_x = BKIP_SCREENW/2;
    }
    [containerView addSubview:toVC.view];
    
    if (!_toShadowView) {
        _toShadowView = [[UIView alloc] initWithFrame:toVC.view.frame];
        _toShadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        [containerView addSubview:_toShadowView];
    }
    
    if (!_fromShadowView) {
        _fromShadowView = [[UIView alloc] initWithFrame:fromVC.view.frame];
        _fromShadowView.backgroundColor = [UIColor whiteColor];
        _fromShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        _fromShadowView.layer.shadowOpacity = 0.45;
        _fromShadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _fromShadowView.layer.shadowRadius = 7;
        [containerView addSubview:_fromShadowView];
    }
    
    [containerView addSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{

        if (self.direction == BKIPTransitionAnimaterDirectionRight) {
            fromVC.view.bk_x = BKIP_SCREENW;
            self.fromShadowView.bk_x = BKIP_SCREENW;
        }else{
            fromVC.view.bk_x = -BKIP_SCREENW;
            self.fromShadowView.bk_x = -BKIP_SCREENW;
        }
        self.fromShadowView.alpha = 0;
        toVC.view.bk_x = 0;
        self.toShadowView.bk_x = 0;
        self.toShadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self.fromShadowView removeFromSuperview];
        self.fromShadowView = nil;
        [self.toShadowView removeFromSuperview];
        self.toShadowView = nil;
        
        if ([transitionContext transitionWasCancelled]) {
            fromVC.view.bk_x = 0;
            [toVC.view removeFromSuperview];
        }else {
            if (self.finishBackCallBack) {
                self.finishBackCallBack();
            }
            [fromVC.view removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


@end
