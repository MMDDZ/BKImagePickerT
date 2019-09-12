//
//  BKImagePickerNavigationController.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePickerNavigationController.h"
#import "BKIPTransitionAnimater.h"
#import "BKIPPercentDrivenInteractiveTransition.h"
#import "UIViewController+BKImagePicker.h"
#import "BKImagePickerHeader.h"

@interface BKImagePickerNavigationController()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

/**
 下一个VC
 */
@property (nonatomic,weak) UIViewController * nextVC;
/**
 过场动画方向
 */
@property (nonatomic,assign) BKIPTransitionAnimaterDirection private_direction;
/**
 交互方法
 */
@property (nonatomic,strong) BKIPPercentDrivenInteractiveTransition * private_transition;
/**
 返回手势是否可用 默认可用
 */
@property (nonatomic,assign) BOOL private_popGestureRecognizerEnable;
/**
 当前VC返回过场动画指定VC
 */
@property (nonatomic,strong) UIViewController * private_popVC;

@end

@implementation BKImagePickerNavigationController

#pragma mark - viewDidLoad

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

#pragma mark - push / pop

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSInteger count = self.viewControllers.count;
    if (count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    _private_popVC = nil;
    _private_popGestureRecognizerEnable = YES;
    
    viewController.pushMessage = @{@"direction":@(_private_direction),
                                   @"popVC":_private_popVC?_private_popVC:[NSNull null],
                                   @"popGestureRecognizerEnable":@(_private_popGestureRecognizerEnable)
                                   };
    
    _nextVC = viewController;
    _private_direction = BKIPTransitionAnimaterDirectionRight;
    _private_transition = nil;
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 自定义过场动画

-(void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    if (!delegate) {
        self.delegate = self;
        [self resetNavSettingWithVC:[self.viewControllers lastObject]];
    }else{
        [super setDelegate:delegate];
    }
}

-(void)setPrivate_popVC:(UIViewController *)private_popVC
{
    _private_popVC = private_popVC;
    
    _nextVC.pushMessage = @{@"direction":_nextVC.pushMessage[@"direction"],
                            @"popVC":_private_popVC?_private_popVC:[NSNull null],
                            @"popGestureRecognizerEnable":@(_private_popGestureRecognizerEnable)
                            };
    
    self.private_transition.backVC = _private_popVC;
}

-(void)setPrivate_popGestureRecognizerEnable:(BOOL)private_popGestureRecognizerEnable
{
    _private_popGestureRecognizerEnable = private_popGestureRecognizerEnable;
    
    self.interactivePopGestureRecognizer.enabled = _private_popGestureRecognizerEnable;
    
    _nextVC.pushMessage = @{@"direction":_nextVC.pushMessage[@"direction"],
                            @"popVC":_private_popVC?_private_popVC:[NSNull null],
                            @"popGestureRecognizerEnable":@(_private_popGestureRecognizerEnable)};
    
    self.private_transition.enble = _private_popGestureRecognizerEnable;
}

#pragma mark - BKIPPercentDrivenInteractiveTransition

-(BKIPPercentDrivenInteractiveTransition*)private_transition
{
    if (!_private_transition) {
        
        NSDictionary * vcMessageDic = _nextVC.pushMessage;
        
        switch ([vcMessageDic[@"direction"] integerValue]) {
            case BKIPTransitionAnimaterDirectionRight:
            {
                _private_transition = [[BKIPPercentDrivenInteractiveTransition alloc] initWithTransitionGestureDirection:BKIPPercentDrivenInteractiveTransitionGestureDirectionRight];
            }
                break;
            case BKIPTransitionAnimaterDirectionLeft:
            {
                _private_transition = [[BKIPPercentDrivenInteractiveTransition alloc] initWithTransitionGestureDirection:BKIPPercentDrivenInteractiveTransitionGestureDirectionLeft];
            }
                break;
            default:
                break;
        }
        
        [_private_transition addPanGestureForViewController:_nextVC];
        
    }
    
    return _private_transition;
}

#pragma mark - UINavigationControllerDelegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    NSDictionary * vcMessageDic = _nextVC.pushMessage;
    
    if (operation == UINavigationControllerOperationPush) {
        
        BKIPTransitionAnimater * transitionAnimater = [[BKIPTransitionAnimater alloc] initWithTransitionType:BKIPTransitionAnimaterTypePush transitionAnimaterDirection:[vcMessageDic[@"direction"] integerValue]];
        
        return transitionAnimater;
    }else{
        
        BKIPTransitionAnimater * transitionAnimater = [[BKIPTransitionAnimater alloc] initWithTransitionType:BKIPTransitionAnimaterTypePop transitionAnimaterDirection:[vcMessageDic[@"direction"] integerValue]];
        transitionAnimater.interation = self.private_transition.interation;
        BKIP_WEAK_SELF(self);
        [transitionAnimater setFinishBackCallBack:^{
            [weakSelf resetNavSettingWithVC:toVC];
        }];
        
        return transitionAnimater;
    }
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.private_transition.interation?self.private_transition:nil;
}

#pragma mark - 重置上一个VC导航设置(返回到导航第一个界面不修改)

-(void)resetNavSettingWithVC:(UIViewController*)currentVC
{
    if ([self.viewControllers firstObject] != currentVC) {
        NSDictionary * vcMessageDic = currentVC.pushMessage;
        self.private_popVC = [vcMessageDic[@"popVC"] isKindOfClass:[NSNull class]]?nil:vcMessageDic[@"popVC"];
        self.private_direction = [vcMessageDic[@"direction"] integerValue];
        self.nextVC = currentVC;
        self.private_popGestureRecognizerEnable = [vcMessageDic[@"popGestureRecognizerEnable"] boolValue];
        
        //重置上一个VC导航交互设置
        self.private_transition = nil;
        [self private_transition];
        UIViewController * popVC = [vcMessageDic[@"popVC"] isKindOfClass:[NSNull class]]?nil:vcMessageDic[@"popVC"];
        if (popVC) {
            self.private_transition.backVC = popVC;
        }
        self.private_transition.enble = [vcMessageDic[@"popGestureRecognizerEnable"] boolValue];
    }
}

#pragma mark - UIGestureRecognizerDelegate 在根视图时不响应interactivePopGestureRecognizer手势

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return [self.viewControllers count] != 1 && ![[self valueForKey:@"isTransitioning"] boolValue];
}

#pragma mark - 屏幕旋转处理

-(BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}


@end
