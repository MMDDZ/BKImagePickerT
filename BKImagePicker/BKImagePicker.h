//
//  BKImagePicker.h
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

FOUNDATION_EXPORT double BKImagePickerVersionNumber;
FOUNDATION_EXPORT const unsigned char BKImagePickerVersionString[];

NS_ASSUME_NONNULL_BEGIN

@interface BKImagePicker : NSObject

#pragma mark - 单例

/**
 单例
 
 @return BKImagePicker
 */
+(instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
