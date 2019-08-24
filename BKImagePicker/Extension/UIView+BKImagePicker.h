//
//  UIView+BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BKImagePicker)

#pragma mark - 附加属性

/**
 x
 */
@property (nonatomic, assign) CGFloat bk_x;
/**
 y
 */
@property (nonatomic, assign) CGFloat bk_y;
/**
 width
 */
@property (nonatomic, assign) CGFloat bk_width;
/**
 height
 */
@property (nonatomic, assign) CGFloat bk_height;
/**
 origin
 */
@property (nonatomic, assign) CGPoint bk_origin;
/**
 size
 */
@property (nonatomic, assign) CGSize bk_size;
/**
 centerX
 */
@property (nonatomic, assign) CGFloat bk_centerX;
/**
 centerY
 */
@property (nonatomic, assign) CGFloat bk_centerY;

@end

NS_ASSUME_NONNULL_END
