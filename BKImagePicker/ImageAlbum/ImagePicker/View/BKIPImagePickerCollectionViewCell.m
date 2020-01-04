//
//  BKIPImagePickerCollectionViewCell.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPImagePickerCollectionViewCell.h"

NSString * const kBKIPImagePickerCollectionViewCellID = @"BKIPImagePickerCollectionViewCell";

@interface BKIPImagePickerCollectionViewCell()

@property (nonatomic,strong) BKImagePickerGradientView * bgGradientView;
@property (nonatomic,strong) UILabel * typeLab;
@property (nonatomic,strong) UILabel * timeLab;

@end

@implementation BKIPImagePickerCollectionViewCell

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.displayImageView.frame = CGRectMake(0, 0, self.contentView.bk_width, self.contentView.bk_height);
    self.selectBtn.frame = CGRectMake(self.contentView.bk_width - 30, 0, 30, 30);
    self.bgGradientView.frame = CGRectMake(0, self.contentView.bk_height/2, self.contentView.bk_width, self.contentView.bk_height/2);
    self.typeLab.frame = CGRectMake(4, self.contentView.bk_height - 4 - self.typeLab.bk_height, self.typeLab.bk_width, self.typeLab.bk_height);
    self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.typeLab.frame), self.typeLab.bk_y, self.contentView.bk_width - (CGRectGetMaxX(self.typeLab.frame) + 4), self.typeLab.bk_height);
}

#pragma mark - initUI

-(void)initUI
{
    self.displayImageView = [[UIImageView alloc] init];
    self.displayImageView.clipsToBounds = YES;
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.displayImageView];
    
    self.selectBtn = [[BKIPImagePickerSelectButton alloc] init];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectBtn];
    if ([BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect == 1) {
        self.selectBtn.hidden = YES;
    }else {
        self.selectBtn.hidden = NO;
    }
    
    self.bgGradientView = [[BKImagePickerGradientView alloc] init];
    self.bgGradientView.startPoint = CGPointMake(0.5, 0);
    self.bgGradientView.endPoint = CGPointMake(0.5, 1);
    self.bgGradientView.colors = @[BKIP_RGBA(102, 102, 102, 0), BKIP_RGBA(0, 0, 0, 0.8)];
    self.bgGradientView.opacity = 1;
    [self.contentView addSubview:self.bgGradientView];
    
    self.typeLab = [[UILabel alloc] init];
    self.typeLab.textColor = BKIP_ImagePicker_VideoMarkColor;
    self.typeLab.font = BKIP_regular_font(10*BKIP_SCREENW/375);
    [self.contentView addSubview:self.typeLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.textColor = BKIP_ImagePicker_VideoTimeTitleColor;
    self.timeLab.font = BKIP_regular_font(10*BKIP_SCREENW/375);
    self.timeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLab];
}

#pragma mark - 触发事件

-(void)selectBtnClick:(UIButton*)button
{
    if (self.model && self.clickSelectBtnCallBack) {
        self.clickSelectBtnCallBack(self.model, self.indexPath);
    }
}

#pragma mark - 赋值

-(void)setModel:(BKImagePickerImageModel *)model indexPath:(NSIndexPath *)indexPath selectIndex:(NSUInteger)selectIndex
{
    _model = model;
    _indexPath = indexPath;
    _selectIndex = selectIndex;
    
    if (_model.coverImage) {
        self.displayImageView.image = model.coverImage;
    }else if (_model.asset) {
        [[BKImagePickerShareManager sharedManager] getThumbImageWithAsset:_model.asset complete:^(UIImage *thumbImage) {
            if (!thumbImage) {
                thumbImage = [UIImage imageWithImageName:@"default_image"];
            }
            self.displayImageView.image = thumbImage;
            if (self.getThumbCoverImageCallBack) {
                self.getThumbCoverImageCallBack(thumbImage, self.indexPath);
            }
        }];
    }else {
        self.displayImageView.image = [UIImage imageWithImageName:@"default_image"];
    }
    
    if (model.photoType == BKIPSelectTypeGIF) {
        self.bgGradientView.opacity = 1;
        self.typeLab.text = @"GIF";
        [self.typeLab sizeToFit];
        self.timeLab.text = @"";
    }else if (model.photoType == BKIPSelectTypeVideo) {
        self.bgGradientView.opacity = 1;
        self.typeLab.text = @"Video";
        [self.typeLab sizeToFit];
        
        NSUInteger allSecond = [[_model.asset valueForKey:@"duration"] integerValue];
        NSString * timeStr = @"";
        if (allSecond > 60) {
            NSInteger second = allSecond%60;
            NSInteger minute = allSecond/60;
            timeStr = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
        }else{
            timeStr = [NSString stringWithFormat:@"00:%02ld", allSecond];
        }
        self.timeLab.text = timeStr;
    }else {
        self.bgGradientView.opacity = 0;
        self.typeLab.text = @"";
        self.timeLab.text = @"";
    }
    
    [self layoutSubviews];
}

@end
