//
//  BKImagePickerGradientView.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePickerGradientView.h"

@interface BKImagePickerGradientView()

@property (nonatomic,strong) CAGradientLayer * gradientLayer;

@end

@implementation BKImagePickerGradientView

-(void)setColors:(NSArray<UIColor *> *)colors
{
    _colors = colors;
    __block NSMutableArray * gLayerColors = [NSMutableArray array];
    [_colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [gLayerColors addObject:(__bridge id)obj.CGColor];
    }];
    self.gradientLayer.colors = [gLayerColors copy];
}

-(void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;
    self.gradientLayer.startPoint = _startPoint;
}

-(void)setEndPoint:(CGPoint)endPoint
{
    _endPoint = endPoint;
    self.gradientLayer.endPoint = _endPoint;
}

-(void)setOpacity:(float)opacity
{
    _opacity = opacity;
    self.gradientLayer.opacity = _opacity;
}

#pragma mark - layoutSubviews

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - CAGradientLayer

-(CAGradientLayer*)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc] init];
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}

@end
