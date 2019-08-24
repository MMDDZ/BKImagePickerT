//
//  NSObject+BKImagePicker.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "NSObject+BKImagePicker.h"
#import <objc/message.h>

@implementation NSObject (BKImagePicker)

-(NSDictionary*)bk_dicTag
{
    return objc_getAssociatedObject(self, @"bk_dicTag");
}

- (void)setBk_dicTag:(NSDictionary *)bk_dicTag
{
    objc_setAssociatedObject(self, @"bk_dicTag", bk_dicTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString*)bk_strTag
{
    return objc_getAssociatedObject(self, @"bk_strTag");
}

-(void)setBk_strTag:(NSString *)bk_strTag
{
    objc_setAssociatedObject(self, @"bk_strTag", bk_strTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 获取当前显示的ViewController

-(UIViewController*)bk_displayViewController
{
    UIViewController * displayVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    BOOL isContinue;
    do {
        if (displayVC.presentedViewController) {
            displayVC = displayVC.presentedViewController;
            isContinue = YES;
        }else if ([displayVC isKindOfClass:[UITabBarController class]]) {
            displayVC = ((UITabBarController*)displayVC).selectedViewController;
            isContinue = YES;
        }else if ([displayVC isKindOfClass:[UINavigationController class]]) {
            displayVC = ((UINavigationController*)displayVC).visibleViewController;
            isContinue = YES;
        }else {
            isContinue = NO;
        }
    } while (isContinue);
    return displayVC;
}

@end
