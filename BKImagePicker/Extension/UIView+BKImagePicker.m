//
//  UIView+BKImagePicker.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "UIView+BKImagePicker.h"
#import "BKImagePickerHeader.h"

@implementation UIView (BKImagePicker)

#pragma mark - 附加属性

-(void)setBk_x:(CGFloat)bk_x
{
    if (bk_x == NAN) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.x = bk_x;
    self.frame = frame;
}

-(CGFloat)bk_x
{
    return self.frame.origin.x;
}

-(void)setBk_y:(CGFloat)bk_y
{
    if (bk_y == NAN) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bk_y;
    self.frame = frame;
}

-(CGFloat)bk_y
{
    return self.frame.origin.y;
}

-(void)setBk_width:(CGFloat)bk_width
{
    if (bk_width == NAN) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.width = bk_width;
    self.frame = frame;
}

-(CGFloat)bk_width
{
    return self.frame.size.width;
}

-(void)setBk_height:(CGFloat)bk_height
{
    if (bk_height == NAN) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = bk_height;
    self.frame = frame;
}

-(CGFloat)bk_height
{
    return self.frame.size.height;
}

-(void)setBk_origin:(CGPoint)bk_origin
{
    CGRect frame = self.frame;
    frame.origin = bk_origin;
    self.frame = frame;
}

-(CGPoint)bk_origin
{
    return self.frame.origin;
}

-(void)setBk_size:(CGSize)bk_size
{
    CGRect frame = self.frame;
    frame.size = bk_size;
    self.frame = frame;
}

-(CGSize)bk_size
{
    return self.frame.size;
}

-(void)setBk_centerX:(CGFloat)bk_centerX
{
    if (bk_centerX == NAN) {
        return;
    }
    
    CGPoint center = self.center;
    center.x = bk_centerX;
    self.center = center;
}

-(CGFloat)bk_centerX
{
    return self.center.x;
}

-(void)setBk_centerY:(CGFloat)bk_centerY
{
    if (bk_centerY == NAN) {
        return;
    }
    
    CGPoint center = self.center;
    center.y = bk_centerY;
    self.center = center;
}

-(CGFloat)bk_centerY
{
    return self.center.y;
}

#pragma mark - Loading

/**
 查找view中是否存在loadLayer
 
 @return loadLayer
 */
-(CALayer*)bk_findLoadLayer
{
    __block CALayer * loadLayer = nil;
    [[self.layer sublayers] enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"loadLayer"]) {
            loadLayer = obj;
            *stop = YES;
        }
    }];
    return loadLayer;
}

/**
 加载Loading
 
 @return loadLayer
 */
-(CALayer*)bk_showLoadLayer
{
    [self bk_hideLoadLayer];
    
    CGFloat scale = BKIP_SCREENW / 320.0f;
    CGFloat prepare_layer_width = self.bounds.size.width/4.0f;
    CGFloat min_layer_width = 60 * scale;
    
    CGFloat loadLayer_width = prepare_layer_width < min_layer_width ? min_layer_width : prepare_layer_width;
    
    CALayer * loadLayer = [CALayer layer];
    loadLayer.bounds = CGRectMake(0, 0, loadLayer_width, loadLayer_width);
    loadLayer.position = CGPointMake(self.bk_width/2, self.bk_height/2);
    loadLayer.backgroundColor = BKIP_Loading_BackgroundColor.CGColor;
    loadLayer.cornerRadius = loadLayer.bounds.size.width/10.0f;
    loadLayer.masksToBounds = YES;
    loadLayer.name = @"loadLayer";
    [self.layer addSublayer:loadLayer];
    
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    for (int i = 0; i < 2; i++) {
        CALayer * circle = [CALayer layer];
        circle.bounds = CGRectMake(0, 0, loadLayer.bounds.size.width/2.0f, loadLayer.bounds.size.height/2.0f);
        circle.position = CGPointMake(loadLayer.bounds.size.width/2.0f, loadLayer.bounds.size.height/2.0f);
        circle.backgroundColor = BKIP_Loading_CircleBackgroundColor.CGColor;
        circle.opacity = 0.6;
        circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5;
        circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
        circle.name = @"loadCircleLayer";
        
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.removedOnCompletion = NO;
        animation.repeatCount = MAXFLOAT;
        animation.duration = 1.5;
        animation.beginTime = beginTime - (0.75 * i);
        animation.keyTimes = @[@(0.0), @(0.5), @(1.0)];
        
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0.0)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)]];
        
        [loadLayer addSublayer:circle];
        [circle addAnimation:animation forKey:@"loading_admin"];
    }
    
    return loadLayer;
}

/**
 加载Loading 带下载进度
 
 @param progress 进度
 */
-(void)bk_showLoadLayerWithDownLoadProgress:(CGFloat)progress
{
    CALayer * loadLayer = [self bk_findLoadLayer];
    if (!loadLayer) {
        
        loadLayer = [self bk_showLoadLayer];
        [self bk_createProgressTextLayerInSupperLayer:loadLayer downLoadProgress:progress];
        
    }else{
        
        __block BOOL isFindFlag = NO;
        [[loadLayer sublayers] enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:@"loadTextLayer"]) {
                CATextLayer * textLayer = (CATextLayer*)obj;
                textLayer.string = [NSString stringWithFormat:@"iCloud同步\n%.0f%%",progress*100];
                isFindFlag = YES;
                *stop = YES;
            }
        }];
        
        if (isFindFlag == NO) {
            [self bk_createProgressTextLayerInSupperLayer:loadLayer downLoadProgress:progress];
        }
    }
}

-(void)bk_createProgressTextLayerInSupperLayer:(CALayer*)supperLayer downLoadProgress:(CGFloat)progress
{
    CGFloat scale = BKIP_SCREENW / 320.0f;
    
    UIFont * font = [UIFont systemFontOfSize:10.0 * scale];
    NSString * string = [NSString stringWithFormat:@"iCloud同步\n%.0f%%",progress*100];
    
    CGFloat height = [string bk_calculateSizeWithUIWidth:supperLayer.frame.size.width font:font].height;
    
    CATextLayer * textLayer = [CATextLayer layer];
    textLayer.bounds = CGRectMake(0, 0, supperLayer.frame.size.width, height);
    textLayer.position = CGPointMake(supperLayer.frame.size.width/2, supperLayer.frame.size.height/2);
    textLayer.string = string;
    textLayer.wrapped = YES;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.foregroundColor = BK_Loading_TitleColor.CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.name = @"loadTextLayer";
    [supperLayer addSublayer:textLayer];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
}

/**
 隐藏Loading
 */
-(void)bk_hideLoadLayer
{
    CALayer * loadLayer = [self bk_findLoadLayer];
    if (!loadLayer) {
        return;
    }
    
    [[loadLayer sublayers] enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"loadCircleLayer"]) {
            [obj removeAnimationForKey:@"loading_admin"];
        }
    }];
    [loadLayer removeFromSuperlayer];
    loadLayer = nil;
}


@end
