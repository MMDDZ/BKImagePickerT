//
//  BKImagePickerModel.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePickerModel.h"

@implementation BKImagePickerModel

-(NSMutableArray<BKImagePickerImageModel *> *)selectImageArray
{
    if (!_selectImageArray) {
        _selectImageArray = [NSMutableArray array];
    }
    return _selectImageArray;
}

@end
