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
 图片位置
 */
@property (nonatomic,assign) BKIPImagePosition imagePosition;

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

/**
 调用方法
 */
@property (nonatomic,strong) NSInvocation * invocation;

@end

@implementation BKImagePickerNavButton

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        [self setupData];
    }
    return self;
}

#pragma mark - 图片init

-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _image = image;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _image = image;
        _imageSize = imageSize;
        
        [self setupData];
    }
    return self;
}

#pragma mark - 标题init

-(instancetype)initWithTitle:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _title = title;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title font:(UIFont*)font
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _title = title;
        _font = font;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title titleColor:(UIColor*)titleColor
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _title = title;
        _titleColor = titleColor;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _title = title;
        _font = font;
        _titleColor = titleColor;
        
        [self setupData];
    }
    return self;
}

#pragma mark - 图片&标题init

-(instancetype)initWithImage:(UIImage *)image title:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _image = image;
        _title = title;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image title:(NSString*)title imagePosition:(BKIPImagePosition)imagePosition
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _image = image;
        _title = title;
        _imagePosition = imagePosition;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _image = image;
        _imageSize = imageSize;
        _title = title;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title imagePosition:(BKIPImagePosition)imagePosition
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _image = image;
        _imageSize = imageSize;
        _title = title;
        _imagePosition = imagePosition;
        
        [self setupData];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image imageSize:(CGSize)imageSize title:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor imagePosition:(BKIPImagePosition)imagePosition
{
    self = [super initWithFrame:CGRectMake(0, BKIP_get_system_statusBar_height(), BKIP_get_system_nav_ui_height(), BKIP_get_system_nav_ui_height())];
    if (self) {
        _image = image;
        _imageSize = imageSize;
        _title = title;
        _font = font;
        _titleColor = titleColor;
        _imagePosition = imagePosition;
        
        [self setupData];
    }
    return self;
}

#pragma mark - 点击方法

-(void)selfTapGestureRecognizer:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self.invocation invoke];
    }
}

-(void)addTarget:(nullable id)target action:(nonnull SEL)action
{
    [self addTarget:target action:action objects:nil];
}

-(void)addTarget:(nullable id)target action:(nonnull SEL)action object:(id)object
{
    [self addTarget:target action:action objects:@[object]];
}

-(void)addTarget:(nullable id)target action:(nonnull SEL)action objects:(NSArray*)objects
{
    Class appearanceClass = NSClassFromString(@"_UIAppearance");
    if ([target isMemberOfClass:appearanceClass]) {
        return;
    }
    
    NSMethodSignature * signature = [[target class] instanceMethodSignatureForSelector:action];
    
    self.invocation = [NSInvocation invocationWithMethodSignature:signature];
    self.invocation.target = target;
    self.invocation.selector = action;
    //   0已经被self占用 1已经被_cmd占用
    if ([objects count] == 1) {
        id param = [objects firstObject];
        [self.invocation setArgument:&param atIndex:2];
    }else if ([objects count] > 1) {
        [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id param = obj;
            [self.invocation setArgument:&param atIndex:2+idx];
        }];
    }
}

#pragma mark - 初始化数据

-(void)setupData
{
    self.backgroundColor = [UIColor clearColor];
    
    if (!_titleColor) {
        self.titleColor = BKIP_HEX_RGB(0x777777);
    }
    
    [self setupRect];
    
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeGestureRecognizer:obj];
    }];
    
    UITapGestureRecognizer * selfTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapGestureRecognizer:)];
    [self addGestureRecognizer:selfTap];
    
    [self setNeedsDisplay];
}

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
        
        if (!_font) {
            _font = [UIFont systemFontOfSize:15];
        }
        
        _titleStr = [self setupTitleStr];
        
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
                _titleStr = [self setupTitleStr];
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
                if (!_font) {
                    _font = [UIFont systemFontOfSize:13];
                }
                _titleStr = [self setupTitleStr];
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
                if (!_font) {
                    _font = [UIFont systemFontOfSize:14];
                }
                _titleStr = [self setupTitleStr];
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
                if (!_font) {
                    _font = [UIFont systemFontOfSize:13];
                }
                _titleStr = [self setupTitleStr];
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

/**
 设置文本
 
 @return 文本
 */
-(NSAttributedString*)setupTitleStr
{
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
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

#pragma mark - 修改

-(void)setTitle:(NSString *)title
{
    _title = title;
    [self setupData];
}

-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self setupData];
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    [self setupData];
}

-(void)setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    [self setupData];
}

-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    if (_image) {
        _image = [_image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        
        CGRect rect = CGRectMake(0, 0, _image.size.width, _image.size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, rect, _image.CGImage);
        CGContextSetFillColorWithColor(context, tintColor.CGColor);
        CGContextFillRect(context, rect);
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _image = [UIImage imageWithCGImage:img.CGImage scale:1 orientation: UIImageOrientationUp];
    }
}

@end
