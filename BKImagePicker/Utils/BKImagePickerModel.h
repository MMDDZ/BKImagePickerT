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

typedef NS_ENUM(NSInteger,BKIPDisplayType) {
    BKIPDisplayTypeDefault = 0,
    BKIPDisplayTypeImageAndGif,
    BKIPDisplayTypeImageAndVideo,
    BKIPDisplayTypeImage
};

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePickerModel : NSObject

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
 预定裁剪大小宽高比
 */
@property (nonatomic,assign) CGFloat clipWHRatio;

@end

NS_ASSUME_NONNULL_END
