//
//  UIViewController+BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/26.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BKImagePicker)

/**
 push时保留的信息
 */
@property (nonatomic,copy) NSDictionary * pushMessage;

@end

NS_ASSUME_NONNULL_END
