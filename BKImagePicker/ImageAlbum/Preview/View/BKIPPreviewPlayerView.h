//
//  BKIPPreviewPlayerView.h
//  BKImagePicker
//
//  Created by zhaolin on 2020/1/4.
//  Copyright © 2020 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKImagePickerHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKIPPreviewPlayerView : UIView

#pragma mark - 播放/暂停

/// 播放的model
@property (nonatomic,strong,readonly) BKImagePickerImageModel * imageModel;
/// 视频的封面图
@property (nonatomic,strong,readonly) UIImage * coverImage;

/// 播放
/// @param imageModel 播放的model
/// @param coverImage 封面图
-(void)playImageModel:(BKImagePickerImageModel*)imageModel coverImage:(UIImage*)coverImage;

/// 停止播放
-(void)stopPlay;

#pragma mark - 回调

/// 播放完成回调
@property (nonatomic,copy) void (^playFinishedCallBack)(void);

@end

NS_ASSUME_NONNULL_END
