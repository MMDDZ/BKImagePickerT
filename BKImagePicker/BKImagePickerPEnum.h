//
//  BKImagePickerPEnum.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#ifndef BKImagePickerPEnum_h
#define BKImagePickerPEnum_h

typedef NS_ENUM(NSInteger,BKIPDisplayType) {
    BKIPDisplayTypeDefault = 0,
    BKIPDisplayTypeImageAndGif,
    BKIPDisplayTypeImageAndVideo,
    BKIPDisplayTypeImage
};

typedef NS_ENUM(NSInteger,BKIPSelectType) {
    BKIPSelectTypeImage = 0,
    BKIPSelectTypeGIF,
    BKIPSelectTypeVideo,
};

#endif /* BKImagePickerPEnum_h */
