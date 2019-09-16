//
//  BKIPImagePickerCollectionReusableFooterView.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPImagePickerCollectionReusableFooterView.h"
#import "BKImagePickerHeader.h"

NSString * const kBKIPImagePickerCollectionReusableFooterViewID = @"BKIPImagePickerCollectionReusableFooterView";

@implementation BKIPImagePickerCollectionReusableFooterView

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
    self.titleLab.frame = CGRectMake(0, 0, self.bk_width, self.bk_height);
}

#pragma mark - initUI

-(void)initUI
{
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:15];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.textColor = BKIP_ImagePicker_ImageNumberTitleColor;
    [self addSubview:_titleLab];
}

@end
