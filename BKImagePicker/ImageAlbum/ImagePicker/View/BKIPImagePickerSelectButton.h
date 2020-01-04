//
//  BKIPImagePickerSelectButton.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKIPImagePickerSelectButton : UIControl

#pragma mark - 属性

/// 标记选中第几个
@property (nonatomic,copy) NSString * title;

#pragma mark - 公开方法

///点击赋值index（有动画）
-(void)selectClickNum:(NSInteger)num;
///刷新赋值index（无动画）
-(void)refreshSelectClickNum:(NSInteger)num;
///取消选中
-(void)cancelSelect;

@end

NS_ASSUME_NONNULL_END
