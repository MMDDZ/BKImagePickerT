//
//  NSString+BKImagePicker.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "NSString+BKImagePicker.h"

@implementation NSString (BKImagePicker)

#pragma mark - 计算文本大小

/**
 计算文本的高
 */
-(CGSize)bk_calculateSizeWithUIWidth:(CGFloat)width font:(UIFont*)font
{
    if (!self || width <= 0 || !font) {
        return CGSizeZero;
    }
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options: NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil];
    
    return rect.size;
}

/**
 计算文本的宽
 */
-(CGSize)bk_calculateSizeWithUIHeight:(CGFloat)height font:(UIFont*)font
{
    if (!self || height <= 0 || !font) {
        return CGSizeZero;
    }
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options: NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    
    return rect.size;
}

@end
