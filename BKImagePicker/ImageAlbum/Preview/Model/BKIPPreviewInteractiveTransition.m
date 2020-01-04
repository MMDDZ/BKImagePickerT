//
//  BKIPPreviewInteractiveTransition.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/12/30.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPPreviewInteractiveTransition.h"
#import "BKImagePickerHeader.h"

@interface BKIPPreviewInteractiveTransition()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) BKIPPreviewViewController * vc;//添加手势的vc
@property (nonatomic,assign) CGFloat startZoomScale;//图片起始在scrollview中缩放大小
@property (nonatomic,assign) CGPoint startContentOffset;//图片起始在scrollview中的偏移量
@property (nonatomic,assign) CGRect startImageViewRect;//图片起始在scrollview中的大小
@property (nonatomic,assign) CGPoint startPoint;//手势起始点
@property (nonatomic,assign) CGRect startPanRect;//手势起始滑动时图片的大小

@property (nonatomic,strong) UIPanGestureRecognizer * panGesture;

@property (nonatomic,strong) UIView * original_lastVCSupperView;//原来上一个vc的supperView
@property (nonatomic,assign) CGFloat changeScale;//过程中改变的大小程度

@end

@implementation BKIPPreviewInteractiveTransition

#pragma mark - 手势

- (void)addPanGestureForViewController:(BKIPPreviewViewController *)viewController
{
    self.vc = viewController;
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    _panGesture.maximumNumberOfTouches = 1;
    _panGesture.delegate = self;
    [viewController.view addGestureRecognizer:_panGesture];
}

/**
 *  手势过渡的过程
 */
- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint nowPoint = [panGesture locationInView:_vc.view];
    
    CGFloat percentage = (nowPoint.y - _startPoint.y) / [UIScreen mainScreen].bounds.size.height;
    if (percentage > 1) {
        percentage = 1;
    }else if (percentage < -0.5) {
        percentage = -0.5;
    }
    
    UIViewController * lastVC = [_vc.navigationController viewControllers][[[_vc.navigationController viewControllers] count] - 2];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            _interation = YES;
            _startZoomScale = _supperScrollView.zoomScale;
            _startContentOffset = _supperScrollView.contentOffset;
            _startPoint = [panGesture locationInView:_panGesture.view];
            
            CGPoint velocity = [panGesture velocityInView:panGesture.view];
            if (velocity.y < fabs(velocity.x)) {
                panGesture.enabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    panGesture.enabled = YES;
                });
                return;
            }
            
            [[_vc.view subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setHidden:YES];
            }];
            
            if (_isNavHidden) {
                self.vc.statusBarHidden = NO;
            }
            
            self.original_lastVCSupperView = [lastVC.view superview];
            [[_vc.view superview] insertSubview:lastVC.view belowSubview:_vc.view];
            
            _startPanRect = [_supperScrollView convertRect:_startImageView.frame toView:self.vc.view];
            
            _supperScrollView.contentOffset = CGPointZero;
            _supperScrollView.zoomScale = 1;
            _startImageViewRect = _startImageView.frame;
            
            _startImageView.frame = _startPanRect;
            
            [_vc.view addSubview:_startImageView];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:panGesture.view];
            CGFloat newY = _startImageView.bk_y + translation.y;
            if (newY <= 0) {
                _vc.view.alpha = 1;
                _startImageView.transform = CGAffineTransformMakeScale(1, 1);
                _startImageView.bk_y = _startImageView.bk_y + translation.y/3.f;
            }else if (newY > 0 && newY <= _startPanRect.origin.y) {
                _vc.view.alpha = 1;
                _startImageView.transform = CGAffineTransformMakeScale(1, 1);
                _startImageView.bk_y = newY;
            }else {
                if (percentage < 0) {
                    self.changeScale = 1;
                }else{
                    self.changeScale = 1 - fabs(0.7*percentage);
                }
                
                if (_vc.navigationController) {
                    _vc.navigationController.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
                }
                _vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:self.changeScale];
                
                _startImageView.transform = CGAffineTransformMakeScale(self.changeScale, self.changeScale);
                _startImageView.bk_y = newY;
            }
            _startImageView.bk_x = _startImageView.bk_x + translation.x;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (percentage > 0.2) {
                [self.original_lastVCSupperView addSubview:lastVC.view];
                [_vc.navigationController popViewControllerAnimated:YES];
            }else{
                [self cancelRecognizerMethodWithPercentage:percentage lastVC:lastVC];
            }
            
            _interation = NO;
            _startPoint = CGPointZero;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self cancelRecognizerMethodWithPercentage:percentage lastVC:lastVC];
            
            _interation = NO;
            _startPoint = CGPointZero;
        }
            break;
        default:
            break;
    }
    
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
}

-(void)cancelRecognizerMethodWithPercentage:(CGFloat)percentage lastVC:(UIViewController*)lastVC
{
    CGFloat duration = percentage < 0 ? fabs(0.75 * percentage) : (1.25 * percentage);
    
    [UIView animateWithDuration:duration animations:^{
        
        self.startImageView.transform = CGAffineTransformIdentity;
        self.startImageView.frame = self.startPanRect;
        
        if (self.vc.navigationController) {
            self.vc.navigationController.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        }
        self.vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        
    } completion:^(BOOL finished) {
        
        [self.supperScrollView addSubview:self.startImageView];
        self.startImageView.frame = self.startImageViewRect;
        self.supperScrollView.zoomScale = self.startZoomScale;
        self.supperScrollView.contentOffset = self.startContentOffset;
        
        [lastVC.view removeFromSuperview];
        [self.original_lastVCSupperView addSubview:lastVC.view];
        
        [[self.vc.view subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setHidden:NO];
        }];
        if (self.isNavHidden) {
            self.vc.statusBarHidden = YES;
        }else{
            self.vc.statusBarHidden = NO;
        }
    }];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == _panGesture) {
        CGPoint point = [_panGesture velocityInView:_panGesture.view];
        if (_supperScrollView.contentOffset.y <= 0 && point.y > fabs(point.x)) {
            otherGestureRecognizer.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                otherGestureRecognizer.enabled = YES;
            });
        }
    }
    return NO;
}

#pragma mark - 获取当前显示view的透明百分比

/**
 获取当前显示view的透明百分比
 
 @return 透明百分比
 */
-(CGFloat)getCurrentViewAlphaPercentage
{
    return self.changeScale;
}

@end
