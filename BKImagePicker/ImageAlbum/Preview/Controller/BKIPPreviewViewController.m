//
//  BKIPPreviewViewController.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/12/30.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPPreviewViewController.h"
#import "BKIPPreviewCollectionViewFlowLayout.h"
#import "BKIPPreviewCollectionViewCell.h"
#import "BKIPImagePickerSelectButton.h"
#import "BKIPImagePickerOriginalButton.h"
#import "BKIPPreviewInteractiveTransition.h"
#import "BKIPPreviewTransitionAnimater.h"
#import "BKIPPreviewPlayerView.h"

@interface BKIPPreviewViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic,assign) BOOL isFirstEnterIntoVC;//是否第一次进入vc

@property (nonatomic,strong) BKIPImagePickerSelectButton * rightNavBtn;

@property (nonatomic,strong) UIButton * editBtn;
@property (nonatomic,strong) BKIPImagePickerOriginalButton * originalBtn;
@property (nonatomic,strong) UIButton * sendBtn;

@property (nonatomic,assign) NSUInteger currentImageIndex;//当前image的index
@property (nonatomic,assign) BOOL isLoadOver;//是否加载完毕

@property (nonatomic,strong) UICollectionView * exampleImageCollectionView;

@property (nonatomic,strong) UINavigationController * nav;//导航
@property (nonatomic,strong) BKIPPreviewInteractiveTransition * interactiveTransition;//交互方法

@property (nonatomic,strong) BKIPPreviewPlayerView * playerView;

@end

@implementation BKIPPreviewViewController

#pragma mark - 显示方法

-(void)showInNav:(UINavigationController*)nav
{
    _nav = nav;
    _nav.delegate = self;
    [_nav pushViewController:self animated:YES];
}

#pragma mark - BKIPPreviewInteractiveTransition

-(BKIPPreviewInteractiveTransition*)interactiveTransition
{
    if (!_interactiveTransition) {
        _interactiveTransition = [[BKIPPreviewInteractiveTransition alloc] init];
        [_interactiveTransition addPanGestureForViewController:self];
    }
    return _interactiveTransition;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        
        UIImageView * imageView = [self getTapImageView];
        
        BKIPPreviewTransitionAnimater * transitionAnimater = [[BKIPPreviewTransitionAnimater alloc] initWithTransitionType:BKShowExampleTransitionPush];
        transitionAnimater.startImageView = imageView;
        transitionAnimater.endRect = [self calculateTargetFrameWithImageView:imageView];
        BKIP_WEAK_SELF(self);
        [transitionAnimater setEndTransitionAnimateAction:^{
            BKIP_STRONG_SELF(self);
            strongSelf.exampleImageCollectionView.hidden = NO;
        }];
        
        return transitionAnimater;
    }else{
        
        CGRect endRect = [self.delegate getFrameOfCurrentImageInListVCWithImageModel:self.imageListArray[_currentImageIndex]];
        
        BKIPPreviewTransitionAnimater * transitionAnimater = [[BKIPPreviewTransitionAnimater alloc] initWithTransitionType:BKShowExampleTransitionPop];
        transitionAnimater.startImageView = self.interactiveTransition.startImageView;
        transitionAnimater.endRect = endRect;
        transitionAnimater.alphaPercentage = self.interactiveTransition.interation?[self.interactiveTransition getCurrentViewAlphaPercentage]:1;
        BKIP_WEAK_SELF(self);
        [transitionAnimater setEndTransitionAnimateAction:^{
            BKIP_STRONG_SELF(self);
            strongSelf.exampleImageCollectionView.hidden = NO;
            strongSelf.nav.delegate = nil;
        }];
        
        return transitionAnimater;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition.interation?self.interactiveTransition:nil;
}

/**
 获取初始点击图片
 
 @return 图片
 */
-(UIImageView*)getTapImageView
{
    CGRect parentRect = [_tapImageView.superview convertRect:_tapImageView.frame toView:self.view];
    
    UIImageView * newImageView = [[UIImageView alloc]initWithFrame:parentRect];
    newImageView.contentMode = UIViewContentModeScaleAspectFill;
    newImageView.clipsToBounds = YES;
    if (_tapImageView.image) {
        newImageView.image = _tapImageView.image;
    }
    
    return newImageView;
}

/**
 获取初始图片动画后frame
 
 @param imageView 初始点击图片
 @return frame
 */
-(CGRect)calculateTargetFrameWithImageView:(UIImageView*)imageView
{
    CGRect targetFrame = CGRectZero;
    
    UIImage * image = imageView.image;
    
    targetFrame.size.width = self.view.frame.size.width;
    if (image) {
        CGFloat scale = image.size.width / targetFrame.size.width;
        targetFrame.size.height = image.size.height/scale;
        if (targetFrame.size.height < self.view.frame.size.height) {
            targetFrame.origin.y = (self.view.frame.size.height - targetFrame.size.height)/2;
        }
    }else{
        targetFrame.size.height = self.view.frame.size.width;
        targetFrame.origin.y = (self.view.frame.size.height - targetFrame.size.height)/2;
    }
    
    return targetFrame;
}

#pragma mark - viewDidload

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFirstEnterIntoVC = YES;
    
    [self initTopNav];
    [self initBottomNav];
    
    [self.view insertSubview:self.exampleImageCollectionView atIndex:0];
    [self.exampleImageCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isFirstEnterIntoVC) {
        [_exampleImageCollectionView reloadItemsAtIndexPaths:[_exampleImageCollectionView indexPathsForVisibleItems]];
        
        [self calculataImageSizeWithSelectIndex:INT_MAX];
        [self refreshBottomNavBtnStateWithSelectIndex:INT_MAX];
    }
    self.isFirstEnterIntoVC = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.nav.delegate = self;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.exampleImageCollectionView.frame = CGRectMake(-BKExampleImagesSpacing, 0, self.view.bk_width + 2*BKExampleImagesSpacing, self.view.bk_height);
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"currentImageIndex"];
}

#pragma mark - initTopNav

-(void)initTopNav
{
    [self addObserver:self forKeyPath:@"currentImageIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    if ([self.imageListArray count] == 1) {
        self.title = @"预览";
    }else{
        if ([_imageListArray count] > 0 && _tapImageModel) {
            self.currentImageIndex = [self.imageListArray indexOfObject:self.tapImageModel];
        }
        self.title = [NSString stringWithFormat:@"%ld/%ld", _currentImageIndex+1, [self.imageListArray count]];
    }
    
    if ([BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect > 1) {
        BKImagePickerNavButton * rightNavBtn = [[BKImagePickerNavButton alloc] init];
        [rightNavBtn addSubview:self.rightNavBtn];
        self.rightNavBtn.frame = CGRectMake((rightNavBtn.bk_width - 30)/2, (rightNavBtn.bk_height - 30)/2, 30, 30);
        self.rightNavBtns = @[rightNavBtn];
    }
}

-(BKIPImagePickerSelectButton*)rightNavBtn
{
    if (!_rightNavBtn) {
        _rightNavBtn = [[BKIPImagePickerSelectButton alloc] init];
        [_rightNavBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.imageListArray count] == 1) {
            if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] == 1) {
                _rightNavBtn.title = @"1";
            }else{
                _rightNavBtn.title = @"0";
            }
        }
    }
    return _rightNavBtn;
}

-(void)rightBtnClick:(BKIPImagePickerSelectButton*)button
{
    BKImagePickerImageModel * model = self.imageListArray[self.currentImageIndex];
    __block BOOL isHave = NO;
    [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray enumerateObjectsUsingBlock:^(BKImagePickerImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.fileName isEqualToString:model.fileName]) {
            isHave = YES;
            *stop = YES;
        }
    }];
    if (!isHave && [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] >= [BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect) {
        BKIP_showMessage([NSString stringWithFormat:@"最多只能选择%ld张照片",[BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect]);
        return;
    }
    
    if (isHave) {
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray removeObject:model];
        [button cancelSelect];
    }else {
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray addObject:model];
        [button selectClickNum:[[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count]];
    }
    
    [self calculataImageSizeWithSelectIndex:INT_MAX];
    [self refreshBottomNavBtnStateWithSelectIndex:INT_MAX];
}

#pragma mark - initBottomNav

-(void)initBottomNav
{
    self.bottomNavViewHeight = BKIP_get_system_tabbar_height();
    
    [self.bottomNavView addSubview:self.editBtn];
    if ([BKImagePickerShareManager sharedManager].imagePickerModel.isHaveOriginal) {
        [self.bottomNavView addSubview:self.originalBtn];
    }
    [self.bottomNavView addSubview:self.sendBtn];
    
    [self refreshBottomNavBtnStateWithSelectIndex:INT_MAX];
}


/**
 更新底部按钮状态

 @param selectIndex 即将选中显示cell的index
 */
-(void)refreshBottomNavBtnStateWithSelectIndex:(NSInteger)selectIndex
{
    __block BOOL canEidtFlag = YES;
    __block BOOL isContainsLoading = NO;
    if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] > 0) {
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKImagePickerImageModel * currentImageModel = obj;
            if (currentImageModel.photoType != BKIPSelectTypeImage) {
                canEidtFlag = NO;
            }
            if (currentImageModel.loadingProgress != 1) {
                isContainsLoading = YES;
            }
            if (canEidtFlag == NO && isContainsLoading == YES) {
                *stop = YES;
            }
        }];
    }else{
        BKImagePickerImageModel * currentImageModel = self.imageListArray[selectIndex==INT_MAX?_currentImageIndex:selectIndex];
        if (currentImageModel.photoType != BKIPSelectTypeImage) {
            canEidtFlag = NO;
        }
        if (currentImageModel.loadingProgress != 1) {
            isContainsLoading = YES;
        }
    }
    
    if (canEidtFlag) {
        [_editBtn setTitleColor:BKIP_ImagePicker_SendHighlightedBackgroundColor forState:UIControlStateNormal];
    }else{
        [_editBtn setTitleColor:BKIP_ImagePicker_SendTitleNormalColor forState:UIControlStateNormal];
    }
    
    if (isContainsLoading) {
        [_sendBtn setTitleColor:BKIP_ImagePicker_SendTitleNormalColor forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:BKIP_ImagePicker_SendTitleNormalColor];
    }else{
        [_sendBtn setTitleColor:BKIP_ImagePicker_SendTitleHighlightedColor forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:BKIP_ImagePicker_SendHighlightedBackgroundColor];
    }
    if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] == 0) {
        [_sendBtn setTitle:@"确认" forState:UIControlStateNormal];
    }else {
        [_sendBtn setTitle:[NSString stringWithFormat:@"确认(%ld)", [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count]] forState:UIControlStateNormal];
    }
}

-(UIButton*)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(0, 0, self.view.bk_width / 6, BKIP_get_system_tabbar_ui_height());
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:BKIP_ImagePicker_SendTitleNormalColor forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

-(BKIPImagePickerOriginalButton*)originalBtn
{
    if (!_originalBtn) {
        _originalBtn = [[BKIPImagePickerOriginalButton alloc] initWithFrame:CGRectMake(BKIP_SCREENW/6, 0, BKIP_SCREENW/7*3, BKIP_get_system_tabbar_ui_height())];
        [_originalBtn addTarget:self action:@selector(originalBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self calculataImageSizeWithSelectIndex:INT_MAX];
    }
    return _originalBtn;
}

-(UIButton*)sendBtn
{
    if (!_sendBtn) {
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(self.view.bk_width/5*4, 6, self.view.bk_width/5-6, 37);
        [_sendBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:BKIP_ImagePicker_SendTitleHighlightedColor forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:BKIP_ImagePicker_SendHighlightedBackgroundColor];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sendBtn.layer.cornerRadius = 4;
        _sendBtn.clipsToBounds = YES;
        [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendBtn;
}

-(void)editBtnClick:(UIButton*)button
{
    if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] > 0) {
        
        __block NSMutableArray * selectImageArr = [NSMutableArray array];
        __block NSInteger prepareIndex = 0;
        
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKImagePickerImageModel * model = obj;
            if (model.photoType != BKIPSelectTypeImage) {
                return;
            }
            
            [selectImageArr addObject:@""];
            
            [self prepareEditWithImageModel:model complete:^(UIImage *image) {
                if (idx < [selectImageArr count]) {
                    [selectImageArr replaceObjectAtIndex:idx withObject:image];
                }
                prepareIndex++;
                
                if (prepareIndex == [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self pushEditImageVCWithEditImageArr:[selectImageArr copy]];
                    });
                }
            }];
        }];
        
    }else{
        BKImagePickerImageModel * model = _imageListArray[_currentImageIndex];
        if (model.photoType != BKIPSelectTypeImage) {
            return;
        }
        
        [self prepareEditWithImageModel:model complete:^(UIImage *image) {
            [self pushEditImageVCWithEditImageArr:@[image]];
        }];
    }
}

-(void)prepareEditWithImageModel:(BKImagePickerImageModel*)imageModel complete:(void (^)(UIImage * image))complete
{
    if (imageModel.loadingProgress == 1) {
        if (complete) {
            complete([UIImage imageWithData:imageModel.originalImageData]);
        }
    }else{
        [[BKImagePickerShareManager sharedManager] getOriginalImageDataWithAsset:imageModel.asset progressHandler:^(double progress, NSError *error, PHImageRequestID imageRequestID) {
            
            imageModel.loadingProgress = progress;
            
        } complete:^(NSData *originalImageData, NSURL *url, PHImageRequestID imageRequestID) {
            
            UIImage * resultImage = [UIImage imageWithData:imageModel.originalImageData];
            if (resultImage) {
                imageModel.originalImageData = originalImageData;
                imageModel.loadingProgress = 1;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    imageModel.thumbImageData = [[BKImagePickerShareManager sharedManager] compressImageData:originalImageData];
                });
                imageModel.url = url;
                imageModel.originalFileSize = (double)originalImageData.length/1024/1024;
                
                if (complete) {
                    complete(resultImage);
                }
            }else{
                imageModel.loadingProgress = 0;
            }
        }];
    }
}

-(void)pushEditImageVCWithEditImageArr:(NSArray<UIImage*>*)imageArr
{
//    BKEditImageViewController * vc = [[BKEditImageViewController alloc]init];
//    vc.editImageArr = imageArr;
//    vc.fromModule = BKEditImageFromModulePhotoAlbum;
//    self.nav.delegate = nil;
//    [self.nav pushViewController:vc animated:YES];
}

-(void)originalBtnClick
{
    [BKImagePickerShareManager sharedManager].imagePickerModel.isOriginal = ![BKImagePickerShareManager sharedManager].imagePickerModel.isOriginal;
    
    [self calculataImageSizeWithSelectIndex:INT_MAX];
}

/**
 计算图的大小

 @param selectIndex 即将选中显示cell的index
 */
-(void)calculataImageSizeWithSelectIndex:(NSInteger)selectIndex
{
    if ([BKImagePickerShareManager sharedManager].imagePickerModel.isOriginal) {
        
        [_originalBtn setTitleColor:BKIP_ImagePicker_SendHighlightedBackgroundColor];
        _originalBtn.selected = YES;
        
        __block double allSize = 0.0;
        __block BOOL isContainsLoading = NO;
        
        if ([BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect == 1) {
            BKImagePickerImageModel * model = self.imageListArray[selectIndex==INT_MAX?_currentImageIndex:selectIndex];
            allSize = model.originalFileSize;
        }else{
            [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BKImagePickerImageModel * model = obj;
                allSize = allSize + model.originalFileSize;
                if (model.loadingProgress != 1) {
                    isContainsLoading = YES;
                    *stop = YES;
                }
            }];
        }
        
        if (isContainsLoading) {
            [_originalBtn setTitle:@"原图(计算中)"];
        }else{
            if (allSize>1024) {
                allSize = allSize / 1024;
                if (allSize > 1024) {
                    allSize = allSize / 1024;
                    [_originalBtn setTitle:[NSString stringWithFormat:@"原图(%.1fT)",allSize]];
                }else{
                    [_originalBtn setTitle:[NSString stringWithFormat:@"原图(%.1fG)",allSize]];
                }
            }else{
                [_originalBtn setTitle:[NSString stringWithFormat:@"原图(%.1fM)",allSize]];
            }
        }
        
    }else{
        [_originalBtn setTitleColor:BKIP_ImagePicker_SendTitleNormalColor];
        _originalBtn.selected = NO;
        [_originalBtn setTitle:@"原图"];
    }
}

-(void)sendBtnClick:(UIButton*)button
{
    if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] == 0) {
        
        BKImagePickerImageModel * model = _imageListArray[_currentImageIndex];
        if (model.loadingProgress != 1) {
            BKIP_showMessage(BKSelectImageDownloadingRemind);
            return;
        }
        
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray addObject:model];
        
    }else{
        
        __block BOOL isContainsLoading = NO;
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKImagePickerImageModel * imageModel = obj;
            if (imageModel.loadingProgress != 1) {
                isContainsLoading = YES;
                *stop = YES;
            }
        }];
        
        if (isContainsLoading == YES) {
            BKIP_showMessage(BKSelectImageDownloadingRemind);
            return;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBKIPFinishSelectImageNotification object:nil userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionView

-(UICollectionView*)exampleImageCollectionView
{
    if (!_exampleImageCollectionView) {
        
        BKIPPreviewCollectionViewFlowLayout * flowLayout = [[BKIPPreviewCollectionViewFlowLayout alloc]init];
        flowLayout.allImageCount = [self.imageListArray count];
        
        _exampleImageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _exampleImageCollectionView.delegate = self;
        _exampleImageCollectionView.dataSource = self;
        _exampleImageCollectionView.backgroundColor = [UIColor clearColor];
        _exampleImageCollectionView.showsVerticalScrollIndicator = NO;
        _exampleImageCollectionView.showsHorizontalScrollIndicator = NO;
        _exampleImageCollectionView.pagingEnabled = YES;
        _exampleImageCollectionView.hidden = YES;
        if (@available(iOS 11.0, *)) {
            _exampleImageCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_exampleImageCollectionView registerClass:[BKIPPreviewCollectionViewCell class] forCellWithReuseIdentifier:kBKIPPreviewCollectionViewCellID];
        
        UITapGestureRecognizer * exampleImageCollectionViewTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exampleImageCollectionViewTapRecognizer)];
        [_exampleImageCollectionView addGestureRecognizer:exampleImageCollectionViewTapRecognizer];
    }
    return _exampleImageCollectionView;
}

-(void)exampleImageCollectionViewTapRecognizer
{
    self.statusBarHidden = !self.statusBarHidden;
    if (self.statusBarHidden) {
        self.topNavView.alpha = 0;
        self.bottomNavView.alpha = 0;
        
        self.interactiveTransition.isNavHidden = YES;
    }else {
        self.topNavView.alpha = 0.8;
        self.bottomNavView.alpha = 0.8;
        
        self.interactiveTransition.isNavHidden = NO;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageListArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BKIPPreviewCollectionViewCell * cell = (BKIPPreviewCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kBKIPPreviewCollectionViewCellID forIndexPath:indexPath];
    BKIP_WEAK_SELF(self);
    [cell setClickPlayCallBack:^(BKIPPreviewCollectionViewCell * _Nonnull currentCell) {
        [weakSelf.playerView playImageModel:currentCell.imageModel coverImage:currentCell.showImageView.image];
        weakSelf.playerView.frame = currentCell.bounds;
        [currentCell addSubview:weakSelf.playerView];
    }];
    
    BKImagePickerImageModel * model = self.imageListArray[indexPath.item];
    cell.imageModel = model;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    BKIPPreviewCollectionViewCell * currentCell = (BKIPPreviewCollectionViewCell*)cell;
    
    currentCell.imageScrollView.zoomScale = 1;

    currentCell.showImageView.frame = [self calculateTargetFrameWithImageView:currentCell.showImageView];
    currentCell.imageScrollView.contentSize = CGSizeMake(currentCell.showImageView.bk_width, currentCell.showImageView.bk_height);
    
    CGFloat scale = currentCell.showImageView.image.size.width / self.view.bk_width;
    currentCell.imageScrollView.maximumZoomScale = scale<2?2:scale;
}

#pragma mark - 获取原图

/// 获取原图
/// @param selectIndexPath 当前indexPath
-(void)loadingOriginalImageDataWithSelectIndexPath:(NSIndexPath*)selectIndexPath
{
    NSIndexPath * currentIndexPath = nil;
    if (!selectIndexPath) {
        currentIndexPath = [NSIndexPath indexPathForItem:_currentImageIndex inSection:0];
    }else{
        currentIndexPath = selectIndexPath;
    }
    BOOL flag = [_exampleImageCollectionView.indexPathsForVisibleItems containsObject:currentIndexPath];

    while (!flag) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadingOriginalImageDataWithSelectIndexPath:selectIndexPath];
        });
        return;
    }

    BKIPPreviewCollectionViewCell * currentCell = (BKIPPreviewCollectionViewCell*)[self.exampleImageCollectionView cellForItemAtIndexPath:currentIndexPath];

    self.interactiveTransition.startImageView = currentCell.showImageView;
    self.interactiveTransition.supperScrollView = currentCell.imageScrollView;

    BKImagePickerImageModel * model = self.imageListArray[currentIndexPath.item];

    if (model.loadingProgress == 1) {
        if (model.photoType == BKIPSelectTypeGIF) {
            SDAnimatedImage * gifImage = [SDAnimatedImage imageWithData:model.originalImageData];
            currentCell.showImageView.image = gifImage;
        }
    }else {
        if (model.photoType == BKIPSelectTypeVideo) {
            [[BKImagePickerShareManager sharedManager] getVideoDataWithAsset:model.asset progressHandler:^(double progress, NSError * _Nonnull error, PHImageRequestID imageRequestID) {
                if (error) {
                    model.loadingProgress = 0;
                }else {
                    model.loadingProgress = progress;
                }
                [[BKImagePickerShareManager sharedManager] updateSelectedImageModel:model];
            } complete:^(AVPlayerItem * _Nonnull playerItem, PHImageRequestID imageRequestID) {
                if (playerItem) {
                    AVURLAsset * avUrlAsset = (AVURLAsset*)playerItem.asset;
                    model.loadingProgress = 1;
                    model.originalFileSize = [[NSData dataWithContentsOfURL:avUrlAsset.URL] length]/1024/1024.0f;
                    model.url = avUrlAsset.URL;
                }else {
                    model.loadingProgress = 0;
                    NSArray * visibleIndexPathArr = [self.exampleImageCollectionView indexPathsForVisibleItems];
                    [visibleIndexPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSIndexPath * indexPath = obj;
                        if (indexPath.item == currentIndexPath.item && indexPath.section == currentIndexPath.section) {
                            BKIP_showMessage(BKVideoDownloadFailedRemind);
                            *stop = YES;
                        }
                    }];
                }
                
                [self calculataImageSizeWithSelectIndex:currentIndexPath.item];
                [self refreshBottomNavBtnStateWithSelectIndex:currentIndexPath.item];
                
                [[BKImagePickerShareManager sharedManager] updateSelectedImageModel:model];
            }];
        }else {
            currentCell.requestID = [[BKImagePickerShareManager sharedManager] getOriginalImageDataWithAsset:model.asset progressHandler:^(double progress, NSError *error, PHImageRequestID imageRequestID) {
                if (error) {
                    [currentCell bk_hideLoadLayer];
                    model.loadingProgress = 0;
                    return;
                }
                [currentCell bk_showLoadLayerWithDownLoadProgress:progress];
                model.loadingProgress = progress;
                
                [[BKImagePickerShareManager sharedManager] updateSelectedImageModel:model];
                
            } complete:^(NSData *originalImageData, NSURL *url, PHImageRequestID imageRequestID) {
                [currentCell bk_hideLoadLayer];
                if (originalImageData) {
                    model.originalImageData = originalImageData;
                    model.loadingProgress = 1;
                    if (model.photoType == BKIPSelectTypeGIF) {
                        SDAnimatedImage * gifImage = [SDAnimatedImage imageWithData:model.originalImageData];
                        currentCell.showImageView.image = gifImage;
                    }
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        model.thumbImageData = [[BKImagePickerShareManager sharedManager] compressImageData:originalImageData];
                    });
                    model.url = url;
                    model.originalFileSize = (double)originalImageData.length/1024/1024.0f;
                }else {
                    model.loadingProgress = 0;
                    NSArray * visibleIndexPathArr = [self.exampleImageCollectionView indexPathsForVisibleItems];
                    [visibleIndexPathArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSIndexPath * indexPath = obj;
                        if (indexPath.item == currentIndexPath.item && indexPath.section == currentIndexPath.section) {
                            BKIP_showMessage(BKOriginalImageDownloadFailedRemind);
                            *stop = YES;
                        }
                    }];
                }
                
                [self calculataImageSizeWithSelectIndex:currentIndexPath.item];
                [self refreshBottomNavBtnStateWithSelectIndex:currentIndexPath.item];
                
                [[BKImagePickerShareManager sharedManager] updateSelectedImageModel:model];
            }];
        }
        
    }
    [self calculataImageSizeWithSelectIndex:currentIndexPath.item];
    [self refreshBottomNavBtnStateWithSelectIndex:currentIndexPath.item];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _exampleImageCollectionView) {
        if (self.isLoadOver) {
            
            CGPoint point = [self.view convertPoint:self.exampleImageCollectionView.center toView:self.exampleImageCollectionView];
            NSIndexPath * currentIndexPath = [self.exampleImageCollectionView indexPathForItemAtPoint:point];
            
            if (self.currentImageIndex != currentIndexPath.item) {
                [self.playerView stopPlay];
                [self.playerView removeFromSuperview];
            }
            self.currentImageIndex = currentIndexPath.item;
            
            BOOL flag = [_exampleImageCollectionView.indexPathsForVisibleItems containsObject:currentIndexPath];
            if (flag) {
                BKIPPreviewCollectionViewCell * currentCell = (BKIPPreviewCollectionViewCell*)[_exampleImageCollectionView cellForItemAtIndexPath:currentIndexPath];
                
                self.interactiveTransition.startImageView = currentCell.showImageView;
                self.interactiveTransition.supperScrollView = currentCell.imageScrollView;
            }
        }
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSIndexPath * selectIndexPath = [self.exampleImageCollectionView indexPathForItemAtPoint:*targetContentOffset];
    if (scrollView == _exampleImageCollectionView) {
        [self loadingOriginalImageDataWithSelectIndexPath:selectIndexPath];
    }
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentImageIndex"]) {
        
        if ([change[@"old"] integerValue] == [change[@"new"] integerValue]) {
            return;
        }
        
        self.titleLab.text = [NSString stringWithFormat:@"%ld/%ld", _currentImageIndex+1, [self.imageListArray count]];
        
        BKImagePickerImageModel * model = self.imageListArray[_currentImageIndex];
        if (self.delegate) {
            [self.delegate refreshLookLocationActionWithImageModel:model];
        }
        
        self.rightNavBtn.title = @"";
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BKImagePickerImageModel * selectModel = obj;
            if ([model.fileName isEqualToString:selectModel.fileName]) {
                self.rightNavBtn.title = [NSString stringWithFormat:@"%ld", idx+1];
                *stop = YES;
            }
        }];
        
    }else if ([keyPath isEqualToString:@"contentSize"]) {
        
        CGFloat contentOffX = (self.view.bk_width + BKExampleImagesSpacing*2) * _currentImageIndex;
        if (self.exampleImageCollectionView.contentSize.width - self.exampleImageCollectionView.bk_width >= contentOffX) {
            [self.exampleImageCollectionView setContentOffset:CGPointMake(contentOffX, 0) animated:NO];
        }
        
        [self.exampleImageCollectionView removeObserver:self forKeyPath:@"contentSize"];
        self.isLoadOver = YES;
        
        [self loadingOriginalImageDataWithSelectIndexPath:nil];
    }
}

#pragma mark - 视频

-(BKIPPreviewPlayerView*)playerView
{
    if (!_playerView) {
        _playerView = [[BKIPPreviewPlayerView alloc] init];
        BKIP_WEAK_SELF(self);
        [_playerView setPlayFinishedCallBack:^{
            [weakSelf.playerView removeFromSuperview];
        }];
    }
    return _playerView;
}

@end
