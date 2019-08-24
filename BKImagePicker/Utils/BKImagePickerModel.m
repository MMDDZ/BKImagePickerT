//
//  BKImagePickerModel.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePickerModel.h"

@implementation BKImagePickerModel

#pragma mark - 属性

-(NSMutableArray<BKImagePickerImageModel *> *)selectImageArray
{
    if (!_selectImageArray) {
        _selectImageArray = [NSMutableArray array];
    }
    return _selectImageArray;
}

#pragma mark - 方法

/**
 初始化属性
 */
-(void)resetProperty
{
    self.isHaveOriginal = NO;
    self.maxSelect = 0;
    [self.selectImageArray removeAllObjects];
    self.isOriginal = NO;
    self.displayType = BKIPDisplayTypeDefault;
    self.aspectRatio = 0;
}

@end
