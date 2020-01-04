//
//  BKIPPreviewCollectionViewCell.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/12/30.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKImagePickerHeader.h"

UIKIT_EXTERN NSString * const _Nullable kBKIPPreviewCollectionViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface BKIPPreviewCollectionViewCell : UICollectionViewCell

#pragma mark - UI

@property (nonatomic,strong) UIScrollView * imageScrollView;
@property (nonatomic,strong) BKIPImageView * showImageView;

#pragma mark - 当前获取图片的id

/// 当前获取图片的id
@property (nonatomic,assign) PHImageRequestID requestID;

#pragma mark - 赋值

@property (nonatomic,strong) BKImagePickerImageModel * imageModel;

#pragma mark - 回调

/// 点击播放回调
@property (nonatomic,copy) void (^clickPlayCallBack)(BKIPPreviewCollectionViewCell * currentCell);

@end

NS_ASSUME_NONNULL_END
