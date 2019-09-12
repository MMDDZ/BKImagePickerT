//
//  UIViewController+BKImagePicker.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/26.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "UIViewController+BKImagePicker.h"
#import <objc/message.h>

@implementation UIViewController (BKImagePicker)

-(NSDictionary*)pushMessage
{
    return objc_getAssociatedObject(self, @"BKImagePicker_pushMessage_viewController");
}

-(void)setPushMessage:(NSDictionary *)pushMessage
{
    objc_setAssociatedObject(self, @"BKImagePicker_pushMessage_viewController", pushMessage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
