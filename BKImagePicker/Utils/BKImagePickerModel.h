//
//  BKImagePickerModel.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BKImagePickerImageModel.h"
#import "BKImagePickerPEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePickerModel : NSObject

#pragma mark - 属性

/**
 是否有原图按钮
 */
@property (nonatomic,assign) BOOL isHaveOriginal;
/**
 最大选取量
 */
@property (nonatomic,assign) NSInteger maxSelect;
/**
 选取的数组
 */
@property (nonatomic,strong) NSMutableArray<BKImagePickerImageModel*> * selectImageArray;
/**
 是否选择原图
 */
@property (nonatomic,assign) BOOL isOriginal;
/**
 相册显示类型
 */
@property (nonatomic,assign) BKIPDisplayType displayType;
/**
 预定裁剪大小宽高比 0代表不裁剪
 */
@property (nonatomic,assign) CGFloat aspectRatio;

#pragma mark - 方法

/**
 初始化属性
 */
-(void)resetProperty;

@end

NS_ASSUME_NONNULL_END
