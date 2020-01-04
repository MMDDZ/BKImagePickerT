//
//  BKIPImagePickerCollectionViewCell.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKIPImagePickerSelectButton.h"
#import "BKImagePickerHeader.h"

UIKIT_EXTERN NSString * _Nonnull const kBKIPImagePickerCollectionViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface BKIPImagePickerCollectionViewCell : UICollectionViewCell

#pragma mark - UI

@property (nonatomic,strong) UIImageView * displayImageView;
@property (nonatomic,strong) BKIPImagePickerSelectButton * selectBtn;

#pragma mark - 回调

/**
 获取到封面缩略图回调
 */
@property (nonatomic,copy) void (^getThumbCoverImageCallBack)(UIImage * coverImage, NSIndexPath * currentIndexPath);
/**
 点击选中回调
 */
@property (nonatomic,copy) void (^clickSelectBtnCallBack)(BKImagePickerImageModel * model, NSIndexPath * currentIndexPath);

#pragma mark - 赋值

@property (nonatomic,strong,readonly) BKImagePickerImageModel * model;
@property (nonatomic,strong,readonly) NSIndexPath * indexPath;
@property (nonatomic,assign,readonly) NSUInteger selectIndex;//第几个选中(0代表未选中)

-(void)setModel:(BKImagePickerImageModel*)model indexPath:(NSIndexPath*)indexPath selectIndex:(NSUInteger)selectIndex;

@end

NS_ASSUME_NONNULL_END
