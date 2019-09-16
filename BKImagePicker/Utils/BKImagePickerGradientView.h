//
//  BKImagePickerGradientView.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePickerGradientView : UIView

/**
 颜色数组
 */
@property (nonatomic, copy) NSArray<UIColor*> * colors;
/**
 起点
 */
@property (nonatomic, assign) CGPoint startPoint;
/**
 终点
 */
@property (nonatomic, assign) CGPoint endPoint;
/**
 透明度
 */
@property (nonatomic, assign) float opacity;

@end

NS_ASSUME_NONNULL_END
