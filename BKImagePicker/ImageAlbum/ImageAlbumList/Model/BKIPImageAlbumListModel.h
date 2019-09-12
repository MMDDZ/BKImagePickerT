//
//  BKIPImageAlbumListModel.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKIPImageAlbumListModel : NSObject

/**
 相册名字
 */
@property (nonatomic,copy) NSString * albumName;
/**
 相册图片数量
 */
@property (nonatomic,assign) NSInteger albumImageCount;
/**
 相册封面图资源
 */
@property (nonatomic,strong) PHAsset * coverAsset;
/**
 相册封面图 (一般是第一张)
 */
@property (nonatomic,strong) UIImage * coverImage;

@end

NS_ASSUME_NONNULL_END
