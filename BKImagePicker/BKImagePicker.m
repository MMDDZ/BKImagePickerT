//
//  BKImagePicker.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePicker.h"
#import "BKImagePickerHeader.h"

@interface BKImagePicker()

@property (nonatomic,strong) id observer;//通知观察者

@end

@implementation BKImagePicker

#pragma mark - 单例

static BKImagePicker * sharedManager = nil;
+(instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [super allocWithZone:zone];
    });
    return sharedManager;
}

@end
