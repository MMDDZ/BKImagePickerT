//
//  BKIPImageAlbumListTableViewCell.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPImageAlbumListTableViewCell.h"
#import "BKImagePickerHeader.h"

NSString * const kBKIPImageAlbumListTableViewCellID = @"BKIPImageAlbumListTableViewCell";

@interface BKIPImageAlbumListTableViewCell()

@property (nonatomic,strong) UIImageView * displayImageView;
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UILabel * countLab;
@property (nonatomic,strong) UIView * line;

@end

@implementation BKIPImageAlbumListTableViewCell

#pragma mark - init

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.displayImageView.frame = CGRectMake(10, 3, self.bk_height - 6, self.bk_height - 6);
    CGFloat titleMaxW = self.contentView.bk_width - (CGRectGetMaxX(self.displayImageView.frame) + 10 + 5 + self.countLab.bk_width + 3);
    self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.displayImageView.frame) + 10, 0, self.titleLab.bk_width > titleMaxW ? titleMaxW : self.titleLab.bk_width, self.bk_height);
    self.countLab.frame = CGRectMake(CGRectGetMaxX(self.titleLab.frame) + 5, 0, self.countLab.bk_width, self.bk_height);
    self.line.frame = CGRectMake(self.titleLab.bk_x, self.bk_height - BKIP_ONE_PIXEL, self.bk_width - self.titleLab.bk_x, BKIP_ONE_PIXEL);
}

#pragma mark - initUI

-(void)initUI
{
    self.displayImageView = [[UIImageView alloc] init];
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.displayImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.displayImageView];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = BKIP_AlbumList_AlbumTitleColor;
    [self.contentView addSubview:self.titleLab];
    
    self.countLab = [[UILabel alloc] init];
    self.countLab.textColor = BKIP_AlbumList_ImageCountColor;
    [self.contentView addSubview:self.countLab];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = BKIP_LINE_COLOR;
    [self addSubview:self.line];
}

#pragma mark - 赋值

-(void)setModel:(BKIPImageAlbumListModel *)model indexPath:(NSIndexPath *)indexPath
{
    _model = model;
    _indexPath = indexPath;
    
    if (_model.coverImage) {
        self.displayImageView.image = model.coverImage;
    }else if (_model.coverAsset) {
        [[BKImagePickerShareManager sharedManager] getThumbImageWithAsset:_model.coverAsset complete:^(UIImage *thumbImage) {
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
    self.titleLab.text = model.albumName;
    [self.titleLab sizeToFit];
    self.countLab.text = [NSString stringWithFormat:@"(%ld)", model.albumImageCount];
    [self.countLab sizeToFit];
    
    [self layoutSubviews];
}

@end
