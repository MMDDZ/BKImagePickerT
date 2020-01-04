//
//  BKIPPreviewCollectionViewCell.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/12/30.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPPreviewCollectionViewCell.h"

NSString * const _Nullable kBKIPPreviewCollectionViewCellID = @"BKIPPreviewCollectionViewCell";

@interface BKIPPreviewCollectionViewCell() <UIScrollViewDelegate>

@property (nonatomic,strong) BKIPImageView * playImageView;

@end

@implementation BKIPPreviewCollectionViewCell

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageScrollView.frame = CGRectMake(BKExampleImagesSpacing, 0, self.bk_width - BKExampleImagesSpacing*2, self.bk_height);
    self.imageScrollView.contentSize = CGSizeMake(self.bk_width - BKExampleImagesSpacing*2, self.bk_height);
    self.playImageView.frame = CGRectMake((self.bk_width - 50)/2, (self.bk_height - 50)/2, 50, 50);
}

#pragma mark - initUI

-(void)initUI
{
    self.imageScrollView = [[UIScrollView alloc] init];
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.delegate = self;
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.minimumZoomScale = 1.0;
    if (@available(iOS 11.0, *)) {
        self.imageScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.imageScrollView];
    
    self.showImageView = [[BKIPImageView alloc] init];
    self.showImageView.userInteractionEnabled = YES;
    self.showImageView.clipsToBounds = YES;
    self.showImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.showImageView.runLoopMode = NSRunLoopCommonModes;
    [self.imageScrollView addSubview:self.showImageView];
    
    self.playImageView = [[BKIPImageView alloc] init];
    self.playImageView.clipsToBounds = YES;
    self.playImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.playImageView.image = [UIImage imageWithImageName:@"BK_Video_play"];
    self.playImageView.userInteractionEnabled = YES;
    self.playImageView.hidden = YES;
    [self addSubview:self.playImageView];
    UITapGestureRecognizer * playImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playImageViewTap)];
    [self.playImageView addGestureRecognizer:playImageViewTap];
}

#pragma mark - 触发事件

-(void)playImageViewTap
{
    if (self.clickPlayCallBack) {
        self.clickPlayCallBack(self);
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageScrollView.contentSize = CGSizeMake(self.showImageView.bk_width, self.showImageView.bk_height);
    
    self.showImageView.bk_centerX = self.showImageView.bk_width > self.imageScrollView.bk_width ? self.imageScrollView.contentSize.width / 2.0f : self.imageScrollView.bk_centerX - BKExampleImagesSpacing;
    self.showImageView.bk_centerY = self.showImageView.bk_height > self.imageScrollView.bk_height ? self.imageScrollView.contentSize.height / 2.0f : self.imageScrollView.bk_centerY;
}

-(nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.showImageView;
}

#pragma mark - 赋值

-(void)setImageModel:(BKImagePickerImageModel *)imageModel
{
    _imageModel = imageModel;
    
    [[BKImagePickerShareManager sharedManager] cancelImageRequest:self.requestID];
    
    if (_imageModel.coverImage) {
        self.showImageView.image = _imageModel.coverImage;
        [self getOriginalImage];
    }else {
        BKIP_WEAK_SELF(self);
        self.requestID = [[BKImagePickerShareManager sharedManager] getThumbImageWithAsset:_imageModel.asset complete:^(UIImage *thumbImage) {
            weakSelf.imageModel.coverImage = thumbImage;
            weakSelf.showImageView.image = weakSelf.imageModel.coverImage;
            [weakSelf getOriginalImage];
        }];
    }
    
    if (_imageModel.photoType == BKIPSelectTypeVideo) {
        self.playImageView.hidden = NO;
    }else {
        self.playImageView.hidden = YES;
    }
}

-(void)getOriginalImage
{
    self.requestID = [[BKImagePickerShareManager sharedManager] getOriginalImageWithAsset:self.imageModel.asset complete:^(UIImage *originalImage) {
        self.showImageView.image = originalImage;
    }];
}

@end
