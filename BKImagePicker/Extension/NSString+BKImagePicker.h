//
//  NSString+BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BKImagePicker)

#pragma mark - 计算文本大小

/**
 计算文本的高
 
 @param width 文本宽
 @param font 文本字体大小
 @return 文本大小
 */
-(CGSize)bk_calculateSizeWithUIWidth:(CGFloat)width font:(UIFont*)font;

/**
 计算文本的宽
 
 @param height 文本高
 @param font 文本字体大小
 @return 文本大小
 */
-(CGSize)bk_calculateSizeWithUIHeight:(CGFloat)height font:(UIFont*)font;

@end

NS_ASSUME_NONNULL_END
