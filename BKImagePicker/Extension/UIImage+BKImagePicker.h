//
//  UIImage+BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BKImagePicker)

#pragma mark - 调整图片方向

/**
 修改图片方向为正方向
 
 @return 图片
 */
-(UIImage*)bk_editImageOrientation;

/**
 修改图片方向
 
 @param orientation 修改方向
 @return 图片
 */
-(UIImage*)bk_editImageOrientation:(UIImageOrientation)orientation;

#pragma mark - 获取图片

/**
 BKImagePicker获取图片
 
 @param imageName 图片名称
 @return 图片
 */
+(UIImage*)imageWithImageName:(NSString*)imageName;

@end

NS_ASSUME_NONNULL_END
