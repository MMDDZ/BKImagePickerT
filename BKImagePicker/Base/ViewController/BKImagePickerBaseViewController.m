//
//  BKImagePickerBaseViewController.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKImagePickerBaseViewController.h"
#import "BKImagePickerHeader.h"

@interface BKImagePickerBaseViewController ()

@property (nonatomic,assign) CGFloat leftNavSpace;
@property (nonatomic,assign) CGFloat rightNavSpace;

@end

@implementation BKImagePickerBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initBaseUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)dealloc
{
    NSLog(@"%@释放",[self class]);
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.topNavView.frame = CGRectMake(0, 0, self.view.bk_width, self.topNavViewHeight);
    CGFloat lrSpace = self.leftNavSpace > self.rightNavSpace ? self.leftNavSpace : self.rightNavSpace;
    self.titleLab.frame = CGRectMake(lrSpace, self.topNavViewHeight - BKIP_get_system_nav_ui_height(), self.topNavView.bk_width - lrSpace*2, BKIP_get_system_nav_ui_height());
    for (BKImagePickerNavButton * currentBtn in self.leftNavBtns) {
        currentBtn.frame = CGRectMake(currentBtn.bk_x, self.topNavViewHeight - currentBtn.bk_height, currentBtn.bk_width, currentBtn.bk_height);
    }
    for (BKImagePickerNavButton * currentBtn in self.rightNavBtns) {
        currentBtn.frame = CGRectMake(currentBtn.bk_x, self.topNavViewHeight - currentBtn.bk_height, currentBtn.bk_width, currentBtn.bk_height);
    }
    self.topLine.frame = CGRectMake(0, self.topNavViewHeight - BKIP_ONE_PIXEL, self.topNavView.bk_width, BKIP_ONE_PIXEL);
    
    self.bottomNavView.frame = CGRectMake(0, self.view.bk_height - self.bottomNavViewHeight, self.view.bk_width, self.bottomNavViewHeight);
    self.bottomLine.frame = CGRectMake(0, 0, self.bottomNavView.bk_width, BKIP_ONE_PIXEL);
}

#pragma mark - 创建UI

-(void)initBaseUI
{
    self.topNavViewHeight = BKIP_get_system_nav_height();
    self.bottomNavViewHeight = 0;
    
    [self.view addSubview:self.topNavView];
    [self.topNavView addSubview:self.titleLab];
    [self.topNavView addSubview:self.topLine];
    
    [self.view addSubview:self.bottomNavView];
    [self.bottomNavView addSubview:self.bottomLine];
    
    if ([self.navigationController.viewControllers count] > 1 && self != [self.navigationController.viewControllers firstObject]) {
        [self addLeftBackNavBtn];
    }
}

#pragma mark - 顶部导航

-(UIView*)topNavView
{
    if (!_topNavView) {
        _topNavView = [[UIView alloc] init];
        _topNavView.backgroundColor = BKIP_NAV_BG_COLOR;
    }
    return _topNavView;
}

-(UILabel*)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = BKIP_NAV_TITLE_COLOR;
        _titleLab.font = BKIP_regular_font(18);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = self.title;
    }
    return _titleLab;
}

-(UIImageView*)topLine
{
    if (!_topLine) {
        _topLine = [[UIImageView alloc] init];
        _topLine.backgroundColor = BKIP_LINE_COLOR;
    }
    return _topLine;
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    _titleLab.text = title;
}

-(void)setTopNavViewHeight:(CGFloat)topNavViewHeight
{
    _topNavViewHeight = topNavViewHeight;
    if ([[self.view subviews] containsObject:self.topNavView]) {
        [self viewWillLayoutSubviews];
    }
}

#pragma mark - 返回按钮

-(void)addLeftBackNavBtn
{
    BKImagePickerNavButton * backBtn = [[BKImagePickerNavButton alloc] initWithImage:[UIImage imageWithImageName:@"DS_nav_back"]];
    [backBtn addTarget:self action:@selector(leftNavBtnAction)];
    self.leftNavBtns = @[backBtn];
}

-(void)leftNavBtnAction
{
    if (self.navigationController) {
        if ([self.navigationController.viewControllers count] != 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)setLeftNavBtns:(NSArray<BKImagePickerNavButton *> *)leftNavBtns
{
    [_leftNavBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _leftNavBtns = leftNavBtns;
    
    BKImagePickerNavButton * lastBtn;
    for (BKImagePickerNavButton * currentBtn in _leftNavBtns) {
        [self.topNavView addSubview:currentBtn];
        currentBtn.frame = CGRectMake(lastBtn ? CGRectGetMaxX(lastBtn.frame) : kBKIPTopNavLeftRightOffset, self.topNavViewHeight - currentBtn.bk_height, currentBtn.bk_width, currentBtn.bk_height);
        lastBtn = currentBtn;
    }
    self.leftNavSpace = CGRectGetMaxX(lastBtn.frame);
}

-(void)setRightNavBtns:(NSArray<BKImagePickerNavButton *> *)rightNavBtns
{
    [_rightNavBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _rightNavBtns = rightNavBtns;
    
    BKImagePickerNavButton * lastBtn;
    for (BKImagePickerNavButton * currentBtn in _rightNavBtns) {
        [self.topNavView addSubview:currentBtn];
        currentBtn.frame = CGRectMake(lastBtn ? (lastBtn.bk_x - currentBtn.bk_width) : (self.topNavView.bk_width - kBKIPTopNavLeftRightOffset - currentBtn.bk_width), self.topNavViewHeight - currentBtn.bk_height, currentBtn.bk_width, currentBtn.bk_height);
        lastBtn = currentBtn;
    }
    self.rightNavSpace = self.topNavView.bk_width - lastBtn.bk_x;
}

#pragma mark - 底部导航

-(UIView*)bottomNavView
{
    if (!_bottomNavView) {
        _bottomNavView = [[UIView alloc] init];
        _bottomNavView.backgroundColor = BKIP_NAV_BG_COLOR;
    }
    return _bottomNavView;
}

-(UIImageView*)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIImageView alloc] init];
        _bottomLine.backgroundColor = BKIP_LINE_COLOR;
    }
    return _bottomLine;
}

-(void)setBottomNavViewHeight:(CGFloat)bottomNavViewHeight
{
    _bottomNavViewHeight = bottomNavViewHeight;
    if ([[self.view subviews] containsObject:self.bottomNavView]) {
        [self viewWillLayoutSubviews];
    }
}

#pragma mark - 状态栏

-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle;
    
    [UIApplication sharedApplication].statusBarStyle = _statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)setStatusBarHidden:(BOOL)statusBarHidden
{
    _statusBarHidden = statusBarHidden;
    
    [UIApplication sharedApplication].statusBarHidden = _statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation
{
    _statusBarHidden = hidden;
    _statusBarUpdateAnimation = animation;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHidden withAnimation:_statusBarUpdateAnimation];
#pragma clang diagnostic pop
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)setStatusBarUpdateAnimation:(UIStatusBarAnimation)statusBarUpdateAnimation
{
    _statusBarUpdateAnimation = statusBarUpdateAnimation;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}

-(BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return self.statusBarUpdateAnimation;
}

#pragma mark - 屏幕旋转处理

// 只支持竖屏
-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
