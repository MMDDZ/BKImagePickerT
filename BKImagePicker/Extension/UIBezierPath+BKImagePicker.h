//
//  UIBezierPath+BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (BKImagePicker)

/**
 获取所有的点

 @return 所有的点
 */
-(NSArray *)bk_points;

@end

NS_ASSUME_NONNULL_END
