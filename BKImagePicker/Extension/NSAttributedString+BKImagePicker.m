//
//  NSAttributedString+BKImagePicker.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "NSAttributedString+BKImagePicker.h"

@implementation NSAttributedString (BKImagePicker)

/**
 计算文本高度(固定宽)
 */
-(CGFloat)bk_calculateHeightWithUIWidth:(CGFloat)width
{
    if (!self || width <= 0) {
        return 0;
    }
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect.size.height;
}

/**
 计算文本宽度(固定高)
 */
-(CGFloat)bk_calculateWidthWithUIHeight:(CGFloat)height
{
    if (!self || height <= 0) {
        return 0;
    }
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect.size.width;
}

@end
