//
//  BKIPImagePickerSelectButton.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/9/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPImagePickerSelectButton.h"
#import "BKImagePickerHeader.h"

@interface BKIPImagePickerSelectButton()

@property (nonatomic,strong) NSString * showTitle;
@property (nonatomic,strong) UIColor * fillColor;

@end

@implementation BKIPImagePickerSelectButton

#pragma mark - setter

-(void)setTitle:(NSString *)title
{
    if ([title length] == 0) {
        self.showTitle = @"";
        self.fillColor = BKIP_ImagePicker_SelectImageNumberNormalBackgroundColor;
    }else{
        self.showTitle = title;
        self.fillColor = BKIP_ImagePicker_SelectImageNumberHighlightedBackgroundColor;
    }
    [self setNeedsDisplay];
}

#pragma mark - getter

-(NSString*)showTitle
{
    if (!_showTitle) {
        _showTitle = @"";
    }
    return _showTitle;
}

-(UIColor*)fillColor
{
    if (!_fillColor) {
        _fillColor = BKIP_ImagePicker_SelectImageNumberNormalBackgroundColor;
    }
    return _fillColor;
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

#pragma mark - drawRect

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [BKIP_ImagePicker_SelectImageNumberBorderColor CGColor]);
    CGContextSetLineWidth(context, 1.5);
    CGContextAddArc(context, self.bk_width/2.0f, self.bk_height/2.0f, self.bk_width/2.0f - 4, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetFillColorWithColor(context, [self.fillColor CGColor]);
    CGContextAddArc(context, self.bk_width/2.0f, self.bk_height/2.0f, self.bk_width/2.0f - 4.5, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);
    
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if ([self.showTitle integerValue] > 99) {
        NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:8], NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : BKIP_ImagePicker_SelectImageNumberTitleColor};
        [self.showTitle drawWithRect:CGRectMake(5, 10, self.bk_width - 10, self.bk_height - 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    }else {
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:BKIP_ImagePicker_SelectImageNumberTitleColor};
        [self.showTitle drawWithRect:CGRectMake(5, 7.5, self.bk_width - 10, self.bk_height - 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    }
}

#pragma mark - 公开方法

-(void)selectClickNum:(NSInteger)num
{
    [self refreshSelectClickNum:num];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(1);
    animation.toValue = @(1.15);
    animation.duration = 0.25;
    animation.autoreverses = YES;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"selectBtnScale"];
}

-(void)refreshSelectClickNum:(NSInteger)num
{
    if (num > 0) {
        self.showTitle = [NSString stringWithFormat:@"%ld", num];
        self.fillColor = BKIP_ImagePicker_SelectImageNumberHighlightedBackgroundColor;
    }else {
        self.showTitle = @"";
        self.fillColor = BKIP_ImagePicker_SelectImageNumberNormalBackgroundColor;
    }
    [self setNeedsDisplay];
}

-(void)cancelSelect
{
    self.showTitle = @"";
    self.fillColor = BKIP_ImagePicker_SelectImageNumberNormalBackgroundColor;
    [self setNeedsDisplay];
}

@end
