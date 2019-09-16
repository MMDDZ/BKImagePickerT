//
//  BKIPImagePickerCollectionReusableFooterView.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * _Nonnull const kBKIPImagePickerCollectionReusableFooterViewID;

NS_ASSUME_NONNULL_BEGIN

@interface BKIPImagePickerCollectionReusableFooterView : UICollectionReusableView

#pragma mark - UI

@property (nonatomic,strong) UILabel * titleLab;

@end

NS_ASSUME_NONNULL_END
