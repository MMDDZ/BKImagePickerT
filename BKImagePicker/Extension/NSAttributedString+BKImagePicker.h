//
//  NSAttributedString+BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (BKImagePicker)

#pragma mark - 计算文本大小

/**
 计算文本高度(固定宽)
 
 @param width 固定宽度
 @return 文本大小
 */
-(CGFloat)bk_calculateHeightWithUIWidth:(CGFloat)width;

/**
 计算文本宽度(固定高)
 
 @param height 固定高度
 @return 文本大小
 */
-(CGFloat)bk_calculateWidthWithUIHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
