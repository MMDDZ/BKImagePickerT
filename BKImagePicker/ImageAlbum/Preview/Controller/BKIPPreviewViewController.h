//
//  BKIPPreviewViewController.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/12/30.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePickerBaseViewController.h"
#import "BKImagePickerHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BKIPPreviewViewControllerDelegate <NSObject>

@optional

/**
 更新浏览位置
 
 @param model 目前观看image数据
 */
-(void)refreshLookLocationActionWithImageModel:(BKImagePickerImageModel*)model;

/**
 获取当前看的图片所在图片列表VC的位置
 
 @param model 目前观看image数据
 */
-(CGRect)getFrameOfCurrentImageInListVCWithImageModel:(BKImagePickerImageModel*)model;

@end

@interface BKIPPreviewViewController : BKImagePickerBaseViewController

/// 代理
@property (nonatomic,weak) id<BKIPPreviewViewControllerDelegate> delegate;

/// 点击的那张图片
@property (nonatomic,strong) UIImageView * tapImageView;
/// 展示数组
@property (nonatomic,copy) NSArray * imageListArray;
/// 选取的imageModel
@property (nonatomic,strong) BKImagePickerImageModel * tapImageModel;

/**
 显示方法
 */
-(void)showInNav:(UINavigationController*)nav;

@end

NS_ASSUME_NONNULL_END
