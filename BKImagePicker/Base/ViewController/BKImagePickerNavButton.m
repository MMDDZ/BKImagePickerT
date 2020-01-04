//
//  BKImagePickerNavButton.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePickerNavButton.h"
#import "BKImagePickerHeader.h"

@interface BKImagePickerNavButton()

/**
 图片Rect
 */
@property (nonatomic,assign) CGRect imageRect;
/**
 标题Rect
 */
@property (nonatomic,assign) CGRect titleRect;
/**
 富文本标题
 */
@property (nonatomic,strong) NSAttributedString * titleStr;

@end

@implementation BKImagePickerNavButton

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutSubviews];
    }
    return self;
}

#pragma mark - 图片init

-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = image;
        [self layoutSubviews];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = image;
        _imageSize = imageSize;
        [self layoutSubviews];
    }
    return self;
}

#pragma mark - 标题init

-(instancetype)initWithTitle:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _title = title;
        [self layoutSubviews];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title font:(UIFont*)font
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _title = title;
        _font = font;
        [self layoutSubviews];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title titleColor:(UIColor*)titleColor
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _title = title;
        _titleColor = titleColor;
        [self layoutSubviews];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _title = title;
        _font = font;
        _titleColor = titleColor;
        [self layoutSubviews];
    }
    return self;
}

#pragma mark - 图片&标题init

-(instancetype)initWithImage:(UIImage *)image title:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = image;
        _title = title;
        [self layoutSubviews];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image title:(NSString*)title imagePosition:(BKIPImagePosition)imagePosition
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = image;
        _title = title;
        _imagePosition = imagePosition;
        [self layoutSubviews];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = image;
        _imageSize = imageSize;
        _title = title;
        [self layoutSubviews];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title imagePosition:(BKIPImagePosition)imagePosition
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = image;
        _imageSize = imageSize;
        _title = title;
        _imagePosition = imagePosition;
        [self layoutSubviews];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor imagePosition:(BKIPImagePosition)imagePosition
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = image;
        _imageSize = imageSize;
        _title = title;
        _font = font;
        _titleColor = titleColor;
        _imagePosition = imagePosition;
        [self layoutSubviews];
    }
    return self;
}

#pragma mark - layoutSubviews

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupRect];
    [self setNeedsDisplay];
}

#pragma mark - 标题属性

-(void)setTitle:(NSString *)title
{
    _title = title;
    [self layoutSubviews];
}

-(void)setFont:(UIFont *)font
{
    _font = font;
    [self layoutSubviews];
}

-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self layoutSubviews];
}

#pragma mark - 图片属性

-(void)setImage:(UIImage *)image
{
    _image = image;
    [self setCsColorImage];
}

-(void)setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    [self layoutSubviews];
}

-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [self setCsColorImage];
}

-(void)setImagePosition:(BKIPImagePosition)imagePosition
{
    _imagePosition = imagePosition;
    [self layoutSubviews];
}

#pragma mark - 修改图片颜色

-(void)setCsColorImage
{
    if (_image) {
        _image = [_image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        
        CGRect rect = CGRectMake(0, 0, _image.size.width, _image.size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, rect, _image.CGImage);
        CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
        CGContextFillRect(context, rect);
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _image = [UIImage imageWithCGImage:img.CGImage scale:1 orientation: UIImageOrientationUp];
    }
    [self layoutSubviews];
}

#pragma mark - 设置初始化内容

/**
 初始化Rect
 */
-(void)setupRect
{
    if (_image && [_title length] == 0) {
        
        if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
            _imageSize = CGSizeMake(23, 23);
        }
        
        if (self.bk_width < _imageSize.width + kBKIPTopNavBtnImageInsets*2) {
            self.bk_width = _imageSize.width + kBKIPTopNavBtnImageInsets*2;
        }
        
        _imageRect = CGRectMake((self.bk_width - _imageSize.width)/2,
                                (self.bk_height - _imageSize.height)/2,
                                _imageSize.width,
                                _imageSize.height);
        
    }else if (!_image && [_title length] != 0) {
    
        _titleStr = [self setupTitleStrWithDefaultTitleFontSize:15];
        
        _titleRect.size.height = [_titleStr bk_calculateHeightWithUIWidth:FLT_MAX];
        _titleRect.origin.y = (self.frame.size.height - _titleRect.size.height)/2;
        _titleRect.origin.x = kBKIPTopNavBtnTitleInsets;
        _titleRect.size.width = [_titleStr bk_calculateWidthWithUIHeight:_titleRect.size.height];
        if (_titleRect.size.width + kBKIPTopNavBtnTitleInsets * 2 < self.bk_width) {
            _titleRect.origin.x = (self.bk_width - _titleRect.size.width)/2;
        }else{
            self.bk_width = _titleRect.size.width + kBKIPTopNavBtnTitleInsets * 2;
        }
        
    }else if (_image && [_title length] > 0) {
        
        switch (_imagePosition) {
            case BKIPImagePositionLeft:
            {
                if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
                    _imageSize = CGSizeMake(23, 23);
                }
                if (!_font) {
                    _font = [UIFont systemFontOfSize:14];
                }
                _titleStr = [self setupTitleStrWithDefaultTitleFontSize:14];
                CGFloat titleHeight = [_titleStr bk_calculateHeightWithUIWidth:FLT_MAX];
                
                _imageRect = CGRectMake(kBKIPTopNavBtnImageInsets,
                                        (self.bk_height - _imageSize.height)/2,
                                        _imageSize.width,
                                        _imageSize.height);
                
                _titleRect.size.height = titleHeight;
                _titleRect.origin.y = (self.frame.size.height - _titleRect.size.height)/2;
                _titleRect.size.width = [_titleStr bk_calculateWidthWithUIHeight:_titleRect.size.height];
                _titleRect.origin.x = CGRectGetMaxX(_imageRect);
                
                self.bk_width = CGRectGetMaxX(_titleRect) + kBKIPTopNavBtnTitleInsets;
            }
                break;
            case BKIPImagePositionTop:
            {
                if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
                    _imageSize = CGSizeMake(20, 20);
                }
           
                _titleStr = [self setupTitleStrWithDefaultTitleFontSize:13];
                CGFloat titleHeight = [_titleStr bk_calculateHeightWithUIWidth:FLT_MAX];
                
                _imageRect = CGRectMake((self.bk_width - _imageSize.width)/2,
                                        0,
                                        _imageSize.width,
                                        _imageSize.height);
                
                _titleRect.size.height = self.bk_height - CGRectGetMaxY(_imageRect);
                if (_titleRect.size.height > titleHeight) {
                    _titleRect.size.height = titleHeight;
                    _imageRect.origin.y = (self.bk_height - _imageSize.height - titleHeight)/2;
                }
                _titleRect.origin.y = CGRectGetMaxY(_imageRect);
                _titleRect.origin.x = 0;
                _titleRect.size.width = self.bk_width;
            }
                break;
            case BKIPImagePositionRight:
            {
                if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
                    _imageSize = CGSizeMake(23, 23);
                }
             
                _titleStr = [self setupTitleStrWithDefaultTitleFontSize:14];
                CGFloat titleHeight = [_titleStr bk_calculateHeightWithUIWidth:FLT_MAX];
                
                _titleRect.size.height = titleHeight;
                _titleRect.origin.y = (self.frame.size.height - _titleRect.size.height)/2;
                _titleRect.size.width = [_titleStr bk_calculateWidthWithUIHeight:_titleRect.size.height];
                _titleRect.origin.x = kBKIPTopNavBtnTitleInsets;
                
                _imageRect = CGRectMake(CGRectGetMaxX(_titleRect),
                                        (self.bk_height - _imageSize.height)/2,
                                        _imageSize.width,
                                        _imageSize.height);
                
                self.bk_width = CGRectGetMaxX(_imageRect) + kBKIPTopNavBtnImageInsets;
            }
                break;
            case BKIPImagePositionBottom:
            {
                if (CGSizeEqualToSize(_imageSize, CGSizeZero)) {
                    _imageSize = CGSizeMake(20, 20);
                }
            
                _titleStr = [self setupTitleStrWithDefaultTitleFontSize:13];
                CGFloat titleHeight = [_titleStr bk_calculateHeightWithUIWidth:FLT_MAX];
                
                _titleRect.size.height = self.bk_height - _imageSize.height;
                if (_titleRect.size.height > titleHeight) {
                    _titleRect.size.height = titleHeight;
                    _titleRect.origin.y = (self.bk_height - _imageSize.height - titleHeight)/2;
                }else{
                    _titleRect.origin.y = 0;
                }
                _titleRect.origin.x = 0;
                _titleRect.size.width = self.bk_width;
                
                _imageRect = CGRectMake((self.bk_width - _imageSize.width)/2,
                                        CGRectGetMaxY(_titleRect),
                                        _imageSize.width,
                                        _imageSize.height);
            }
                break;
            default:
                break;
        }
    }
}

/// 设置文本
/// @param dFontSize 字号
-(NSAttributedString*)setupTitleStrWithDefaultTitleFontSize:(CGFloat)dFontSize
{
    if (!_font) {
        _font = [UIFont systemFontOfSize:dFontSize];
    }
    if (!_titleColor) {
        _titleColor = BKIP_NAV_BTN_TITLE_COLOR;
    }
    
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString * titleStr = [[NSAttributedString alloc] initWithString:_title attributes:@{NSFontAttributeName:_font,
                     NSForegroundColorAttributeName:_titleColor,
                     NSParagraphStyleAttributeName:paragraphStyle}];
    
    return titleStr;
}

#pragma mark - drawRect

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_image && [_title length] == 0) {
        [_image drawInRect:_imageRect];
    }else if (!_image && [_title length] != 0) {
        [_titleStr drawInRect:_titleRect];
    }else if (_image && [_title length] > 0) {
        [_image drawInRect:_imageRect];
        [_titleStr drawInRect:_titleRect];
    }
}

@end
