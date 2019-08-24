//
//  NSObject+BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BKImagePicker)

/**
 字典Tag
 */
@property (nonatomic,strong) NSDictionary * bk_dicTag;

/**
 字符串Tag
 */
@property (nonatomic,strong) NSString * bk_strTag;

#pragma mark - 获取当前显示的ViewController

/**
 当前显示的控制器
 */
@property (nonatomic,weak,readonly) UIViewController * bk_displayViewController;

@end

NS_ASSUME_NONNULL_END
