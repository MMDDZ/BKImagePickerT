//
//  BKImagePickerNavigationController.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+BKImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePickerNavigationController : UINavigationController

#pragma mark - 自定义过场动画

/**
 是否是其他自定义push动画
 如果采用其他自定义push动画 在push前设置delegate = 对应类; pop后或者push下一个vc不采用其他自定义push动画前设置导航delegate = nil
 */

@end

NS_ASSUME_NONNULL_END
