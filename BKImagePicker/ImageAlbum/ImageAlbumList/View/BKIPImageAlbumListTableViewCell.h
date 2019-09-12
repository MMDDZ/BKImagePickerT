//
//  BKIPImageAlbumListTableViewCell.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKIPImageAlbumListModel.h"

UIKIT_EXTERN NSString * _Nonnull const kBKIPImageAlbumListTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface BKIPImageAlbumListTableViewCell : UITableViewCell

#pragma mark - 赋值

@property (nonatomic,strong,readonly) BKIPImageAlbumListModel * model;
@property (nonatomic,strong,readonly) NSIndexPath * indexPath;

-(void)setModel:(BKIPImageAlbumListModel*)model indexPath:(NSIndexPath*)indexPath;

#pragma mark - 回调

/**
 获取到封面缩略图回调
 */
@property (nonatomic,copy) void (^getThumbCoverImageCallBack)(UIImage * coverImage, NSIndexPath * currentIndexPath);

@end

NS_ASSUME_NONNULL_END
