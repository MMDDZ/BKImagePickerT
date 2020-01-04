//
//  BKIPImagePickerOriginalButton.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/12/31.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPImagePickerOriginalButton.h"
#import "BKImagePickerHeader.h"

@implementation BKIPImagePickerOriginalButton

#pragma mark - setter

-(void)setTitle:(NSString *)title
{
    _title = title;
    [self setNeedsDisplay];
}

-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
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
    
    if (self.isSelected) {
        CGContextSetFillColorWithColor(context, BKIP_ImagePicker_SendHighlightedBackgroundColor.CGColor);
        CGContextAddArc(context, 12, self.bk_height/2, 10, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextSetStrokeColorWithColor(context, BKIP_ImagePicker_OriginalImageHookColor.CGColor);
        CGContextMoveToPoint(context, 12 - 6, self.bk_height/2);
        CGContextAddLineToPoint(context, 12 - 2, self.bk_height/2 + 4);
        CGContextAddLineToPoint(context, 12 + 6, self.bk_height/2 - 4);
        CGContextSetLineWidth(context, 1.5);
        CGContextDrawPath(context, kCGPathStroke);
    }else {
        CGContextSetStrokeColorWithColor(context, [BKIP_ImagePicker_SelectImageNumberNormalBackgroundColor CGColor]);
        CGContextSetLineWidth(context, 1);
        CGContextAddArc(context, 12, self.bk_height/2, 10, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15], NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : _titleColor};
    [self.title drawWithRect:CGRectMake(28, 15, self.bk_width - 30, (self.bk_height - 15)/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

@end
