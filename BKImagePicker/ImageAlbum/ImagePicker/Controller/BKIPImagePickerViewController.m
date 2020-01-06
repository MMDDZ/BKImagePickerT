//
//  BKIPImagePickerViewController.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPImagePickerViewController.h"
#import "BKImagePicker.h"
#import "BKImagePickerHeader.h"
#import "BKIPImagePickerCollectionViewCell.h"
#import "BKIPImagePickerCollectionReusableFooterView.h"
#import "BKIPPreviewViewController.h"
#import "BKIPImagePickerOriginalButton.h"

@interface BKIPImagePickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, BKIPPreviewViewControllerDelegate>

@property (nonatomic,strong) UICollectionView * collectionView;

/// 资源数组
@property (nonatomic,strong) NSMutableArray<BKImagePickerImageModel*> * assetListArray;

/// 该相簿中所有照片和视频总数
@property (nonatomic,assign) NSUInteger allAssestNum;
/// 该相簿中除gif外所有其他类型照片总数
@property (nonatomic,assign) NSUInteger allImageNum;
/// 该相簿中所有GIF照片总数
@property (nonatomic,assign) NSUInteger allGifImageNum;
/// 该相簿中所有视频总数
@property (nonatomic,assign) NSUInteger allVideoNum;

/// 预览按钮
@property (nonatomic,strong) UIButton * previewBtn;
/// 原图按钮
@property (nonatomic,strong) BKIPImagePickerOriginalButton * originalBtn;
/// 发送按钮
@property (nonatomic,strong) UIButton * sendBtn;

@end

@implementation BKIPImagePickerViewController

#pragma mark - 获取图片

-(NSMutableArray<BKImagePickerImageModel *> *)assetListArray
{
    if (!_assetListArray) {
        _assetListArray = [NSMutableArray array];
    }
    return _assetListArray;
}

-(void)getAllAssetCollection
{
    //系统的相簿
    PHFetchResult * smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    BOOL systemFlag = [self getSingleAlbum:smartAlbums];
    //进入的相册属于系统相簿 return
    if (systemFlag) {
        return;
    }
    
    //用户自己创建的相簿
    PHFetchResult * userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    BOOL userFlag = [self getSingleAlbum:userAlbums];
    //进入的相册属于用户自己创建的相簿 return
    if (userFlag) {
        return;
    }
}

-(BOOL)getSingleAlbum:(PHFetchResult*)fetchResult
{
    __block BOOL isFind = NO;
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *collection = obj;
        //查询进入的相册是否相同
        if ([collection.localizedTitle isEqualToString:self.title]) {
            // 获取所有资源的集合按照创建时间排列
            PHFetchOptions * fetchOptions = [[PHFetchOptions alloc] init];
            fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d || mediaType = %d", PHAssetMediaTypeImage, PHAssetMediaTypeVideo];
            PHFetchResult<PHAsset *> * assets  = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
            //该相册下所有的资源
            self.allAssestNum = [assets count];
            //遍历资源
            [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //创建资源model
                BKImagePickerImageModel * model = [[BKImagePickerImageModel alloc] init];
                model.asset = obj;
                //资源文件名称
                NSString * fileName = [obj valueForKey:@"filename"];
                model.fileName = fileName;
                
                if (obj.mediaType == PHAssetMediaTypeImage) {
                    if ([[fileName uppercaseString] rangeOfString:@"GIF"].location == NSNotFound) {
                        self.allImageNum++;
                        model.photoType = BKIPSelectTypeImage;
                    }else{
                        self.allGifImageNum++;
                        model.photoType = BKIPSelectTypeGIF;
                    }
                }else{
                    self.allVideoNum++;
                    model.photoType = BKIPSelectTypeVideo;
                }
                
                switch ([BKImagePickerShareManager sharedManager].imagePickerModel.displayType) {
                    case BKIPDisplayTypeDefault:
                    {
                        [self.assetListArray addObject:model];
                    }
                        break;
                    case BKIPDisplayTypeImageAndGif:
                    {
                        if (obj.mediaType == PHAssetMediaTypeImage) {
                            [self.assetListArray addObject:model];
                        }else{
                            self.allAssestNum--;
                        }
                    }
                        break;
                    case BKIPDisplayTypeImageAndVideo:
                    {
                        if ([[fileName uppercaseString] rangeOfString:@"GIF"].location == NSNotFound) {
                            [self.assetListArray addObject:model];
                        }else{
                            self.allAssestNum--;
                        }
                    }
                        break;
                    case BKIPDisplayTypeImage:
                    {
                        if (obj.mediaType == PHAssetMediaTypeImage) {
                            if ([[fileName uppercaseString] rangeOfString:@"GIF"].location == NSNotFound) {
                                [self.assetListArray addObject:model];
                            }else{
                                self.allAssestNum--;
                            }
                        }else{
                            self.allAssestNum--;
                        }
                    }
                        break;
                }
            }];
            isFind = YES;
            *stop = YES;
        }
    }];
    if (isFind) {
        [self.collectionView reloadData];
    }
    return isFind;
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.collectionView.contentSize.height > self.collectionView.bk_height) {
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.bk_height) animated:NO];
        }
        [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
    }
}

#pragma mark - viewDidLoad

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.allAssestNum = 0;
    self.allImageNum = 0;
    self.allGifImageNum = 0;
    self.allVideoNum = 0;
    
    [self initTopNav];
    if ([BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect > 1) {
        [self initBottomNav];
    }
    
    [self.view insertSubview:self.collectionView atIndex:0];
    [self getAllAssetCollection];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.view.bk_width, self.view.bk_height - self.bottomNavViewHeight);
}

#pragma mark - initTopNav

-(void)initTopNav
{
    BKImagePickerNavButton * rightNavBtn = [[BKImagePickerNavButton alloc] initWithTitle:@"取消" font:[UIFont systemFontOfSize:16] titleColor:BKIP_NAV_BTN_TITLE_COLOR];
    [rightNavBtn addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.rightNavBtns = @[rightNavBtn];
}

-(void)rightNavBtnClick
{
    id observer = [[BKImagePicker sharedManager] valueForKey:@"observer"];
    if (observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - initBottomNav

-(void)initBottomNav
{
    self.bottomNavViewHeight = BKIP_get_system_tabbar_height();
    
    [self.bottomNavView addSubview:self.previewBtn];
    if ([BKImagePickerShareManager sharedManager].imagePickerModel.isHaveOriginal) {
        [self.bottomNavView addSubview:self.originalBtn];
    }
    [self.bottomNavView addSubview:self.sendBtn];
}

/**
 更新底部按钮状态
 */
-(void)refreshBottomNavBtnState
{
    if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] <= 0) {
        [self.previewBtn setTitleColor:BKIP_ImagePicker_SendTitleNormalColor forState:UIControlStateNormal];
        
        [self.sendBtn setTitleColor:BKIP_ImagePicker_SendTitleNormalColor forState:UIControlStateNormal];
        [self.sendBtn setBackgroundColor:BKIP_ImagePicker_SendNormalBackgroundColor];
        [self.sendBtn setTitle:@"确认" forState:UIControlStateNormal];
    }else {
        [self.previewBtn setTitleColor:BKIP_ImagePicker_SendHighlightedBackgroundColor forState:UIControlStateNormal];
        
        [self.sendBtn setTitleColor:BKIP_ImagePicker_SendTitleHighlightedColor forState:UIControlStateNormal];
        [self.sendBtn setBackgroundColor:BKIP_ImagePicker_SendHighlightedBackgroundColor];
        [self.sendBtn setTitle:[NSString stringWithFormat:@"确认(%ld)",[[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count]] forState:UIControlStateNormal];
    }
}

#pragma mark - 预览按钮

-(UIButton*)previewBtn
{
    if (!_previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewBtn.frame = CGRectMake(0, 0, self.view.bk_width/6, BKIP_get_system_tabbar_ui_height());
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:BKIP_ImagePicker_SendTitleNormalColor forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}

-(void)previewBtnClick:(UIButton*)button
{
    if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] == 0) {
        return;
    }
    
    BKImagePickerImageModel * model = [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray lastObject];
    __block BOOL isHaveFlag = NO;
    __block NSInteger item = 0;
    [self.assetListArray enumerateObjectsUsingBlock:^(BKImagePickerImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.fileName isEqualToString:model.fileName]) {
            item = idx;
            isHaveFlag = YES;
            *stop = YES;
        }
    }];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    
    if (!isHaveFlag) {
        [self previewWithCell:nil imageListArray:[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray tapModel:[[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray lastObject]];
    }else{
        BKIPImagePickerCollectionViewCell * cell = (BKIPImagePickerCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (!cell) {
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BKIPImagePickerCollectionViewCell * cell = (BKIPImagePickerCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                [self previewWithCell:cell imageListArray:[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray tapModel:[[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray lastObject]];
            });
        }else{
            [self previewWithCell:cell imageListArray:[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray tapModel:[[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray lastObject]];
        }
    }
}

#pragma mark - 原图按钮

-(BKIPImagePickerOriginalButton*)originalBtn
{
    if (!_originalBtn) {
        _originalBtn = [[BKIPImagePickerOriginalButton alloc] initWithFrame:CGRectMake(self.view.bk_width/6, 0, self.view.bk_width/7*3, BKIP_get_system_tabbar_ui_height())];
        [_originalBtn addTarget:self action:@selector(originalBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self calculataImageSize];
    }
    return _originalBtn;
}

-(void)originalBtnClick
{
    [BKImagePickerShareManager sharedManager].imagePickerModel.isOriginal = ![BKImagePickerShareManager sharedManager].imagePickerModel.isOriginal;
    
    [self calculataImageSize];
}

#pragma mark - 计算选中图片的大小

-(void)calculataImageSize
{
    if ([BKImagePickerShareManager sharedManager].imagePickerModel.isOriginal) {
        
        [_originalBtn setTitleColor:BKIP_ImagePicker_SendHighlightedBackgroundColor];
        _originalBtn.selected = YES;
        
        __block double allSize = 0.0;
        __block BOOL isContainsLoading = NO;
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray enumerateObjectsUsingBlock:^(BKImagePickerImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            allSize = allSize + obj.originalFileSize;
            if (obj.loadingProgress != 1) {
                isContainsLoading = YES;
                *stop = YES;
            }
        }];
        
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

#pragma mark - 发送按钮

-(UIButton*)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(self.view.bk_width/5*4, 6, self.view.bk_width/5-6, 37);
        [_sendBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:BKIP_ImagePicker_SendTitleNormalColor forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:BKIP_ImagePicker_SendNormalBackgroundColor];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sendBtn.layer.cornerRadius = 4;
        _sendBtn.clipsToBounds = YES;
        [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

-(void)sendBtnClick:(UIButton*)button
{
    if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] == 0) {
        BKIP_showMessage(BKPleaseSelectImageRemind);
        return;
    }
    
    __block BOOL isContainsLoading = NO;
    [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray enumerateObjectsUsingBlock:^(BKImagePickerImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.loadingProgress != 1) {
            isContainsLoading = YES;
            *stop = YES;
        }
    }];
    
    if (isContainsLoading == YES) {
        BKIP_showMessage(BKSelectImageDownloadingRemind);
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBKIPFinishSelectImageNotification object:nil userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionView

-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((self.view.bk_width - BKAlbumImagesSpacing*5)/4, (self.view.bk_width - BKAlbumImagesSpacing*5)/4);
        flowLayout.minimumLineSpacing = BKAlbumImagesSpacing;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(BKAlbumImagesSpacing, BKAlbumImagesSpacing, BKAlbumImagesSpacing, BKAlbumImagesSpacing);
        [flowLayout setFooterReferenceSize:CGSizeMake(self.view.bk_width, 40)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topNavViewHeight, 0, 0, 0);
        _collectionView.contentInset = UIEdgeInsetsMake(self.topNavViewHeight, 0, 0, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[BKIPImagePickerCollectionViewCell class] forCellWithReuseIdentifier:kBKIPImagePickerCollectionViewCellID];
        [_collectionView registerClass:[BKIPImagePickerCollectionReusableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kBKIPImagePickerCollectionReusableFooterViewID];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _collectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetListArray count];
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BKIPImagePickerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBKIPImagePickerCollectionViewCellID forIndexPath:indexPath];
    BKIP_WEAK_SELF(self);
    [cell setGetThumbCoverImageCallBack:^(UIImage * _Nonnull coverImage, NSIndexPath * _Nonnull currentIndexPath) {
        BKImagePickerImageModel * model = weakSelf.assetListArray[currentIndexPath.item];
        model.coverImage = coverImage;
        [weakSelf.assetListArray replaceObjectAtIndex:currentIndexPath.item withObject:model];
    }];
    [cell setClickSelectBtnCallBack:^(BKImagePickerImageModel * _Nonnull model, NSIndexPath * _Nonnull currentIndexPath) {
        [weakSelf clickSelectImageAction:model currentIndexPath:currentIndexPath];
    }];
    
    BKImagePickerImageModel * model = self.assetListArray[indexPath.item];
    [cell setModel:model indexPath:indexPath selectIndex:0];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter){
        
        BKIPImagePickerCollectionReusableFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kBKIPImagePickerCollectionReusableFooterViewID forIndexPath:indexPath];
        
        switch ([BKImagePickerShareManager sharedManager].imagePickerModel.displayType) {
            case BKIPDisplayTypeDefault:
            {
                footerView.titleLab.text = [NSString stringWithFormat:@"共%ld张照片、%ld个GIF、%ld个视频", self.allImageNum, self.allGifImageNum, self.allVideoNum];
            }
                break;
            case BKIPDisplayTypeImageAndGif:
            {
                footerView.titleLab.text = [NSString stringWithFormat:@"共%ld张照片、%ld个GIF", self.allImageNum, self.allGifImageNum];
            }
                break;
            case BKIPDisplayTypeImageAndVideo:
            {
                footerView.titleLab.text = [NSString stringWithFormat:@"共%ld张照片、%ld个视频", self.allImageNum, self.allVideoNum];
            }
                break;
            case BKIPDisplayTypeImage:
            {
                footerView.titleLab.text = [NSString stringWithFormat:@"共%ld张照片", self.allImageNum];
            }
                break;
        }
        
        reusableview = footerView;
    }
    
    return reusableview;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BKImagePickerImageModel * model = self.assetListArray[indexPath.item];

    BKIPImagePickerCollectionViewCell * cell = (BKIPImagePickerCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (!cell) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BKIPImagePickerCollectionViewCell * cell = (BKIPImagePickerCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
            [self previewWithCell:cell imageListArray:self.assetListArray tapModel:model];
        });
    }else{
        [self previewWithCell:cell imageListArray:self.assetListArray tapModel:model];
    }
    
    
//    if (model.asset.mediaType == PHAssetMediaTypeImage) {

//        //当裁剪比例不为0时 进入裁剪状态
//        if ([BKImagePickerShareManager sharedManager].imagePickerModel.clipSize_width_height_ratio != 0) {
//
//            [[BKImagePicker sharedManager] getOriginalImageWithAsset:model.asset complete:^(UIImage *originalImage) {
//                BKEditImageViewController * vc = [[BKEditImageViewController alloc] init];
//                vc.editImageArr = @[originalImage];
//                vc.fromModule = BKEditImageFromModulePhotoAlbum;
//                [self.navigationController pushViewController:vc animated:YES];
//            }];
//
//        }else {
            
//        }

//    }else {
//        if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] > 0) {
//            BKIP_showMessage(BKCanNotSelectBothTheImageAndVideoRemind);
//            return;
//        }
//
//        BKVideoPreviewViewController * vc = [[BKVideoPreviewViewController alloc]init];
//        vc.tapVideoModel = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

-(void)previewWithCell:(BKIPImagePickerCollectionViewCell*)cell imageListArray:(NSArray*)imageListArray tapModel:(BKImagePickerImageModel*)tapModel
{
    if (!cell.displayImageView.image && cell) {
        return;
    }

    BKIPPreviewViewController * vc = [[BKIPPreviewViewController alloc]init];
    vc.delegate = self;
    vc.tapImageView = cell.displayImageView;
    vc.imageListArray = [imageListArray copy];
    vc.tapImageModel = tapModel;
    [vc showInNav:self.navigationController];
}

#pragma mark - BKIPPreviewViewControllerDelegate

-(void)refreshLookLocationActionWithImageModel:(BKImagePickerImageModel*)model
{
    __block BOOL isHaveFlag = NO;
    __block NSInteger item = 0;
    [self.assetListArray enumerateObjectsUsingBlock:^(BKImagePickerImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.fileName isEqualToString:model.fileName]) {
            item = idx;
            isHaveFlag = YES;
            *stop = YES;
        }
    }];
    
    if (isHaveFlag) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        BKIPImagePickerCollectionViewCell * cell = (BKIPImagePickerCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (!cell) {
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }
    }
}

-(CGRect)getFrameOfCurrentImageInListVCWithImageModel:(BKImagePickerImageModel*)model
{
    __block BOOL isHaveFlag = NO;
    __block NSInteger item = 0;
    [self.assetListArray enumerateObjectsUsingBlock:^(BKImagePickerImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.fileName isEqualToString:model.fileName]) {
            item = idx;
            isHaveFlag = YES;
            *stop = YES;
        }
    }];
    
    if (isHaveFlag) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        CGRect in_list_rect = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath].frame;
        CGRect in_view_rect = [self.collectionView convertRect:in_list_rect toView:self.view];
        return in_view_rect;
    }else{
        return CGRectZero;
    }
}

#pragma mark - 选中图片/取消选中图片

-(void)clickSelectImageAction:(BKImagePickerImageModel*)imageModel currentIndexPath:(NSIndexPath*)currentIndexPath
{
    __block BOOL isHave = NO;
    __block NSInteger currentIndex;
    [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray enumerateObjectsUsingBlock:^(BKImagePickerImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.fileName isEqualToString:imageModel.fileName]) {
            currentIndex = idx;
            isHave = YES;
        }
        
        NSArray * visibleCellArr = [self.collectionView visibleCells];
        for (int i = 0; i < [visibleCellArr count]; i++) {
            BKIPImagePickerCollectionViewCell * cell = visibleCellArr[i];
            if ([obj.fileName isEqualToString:cell.model.fileName]) {
                if (isHave) {
                    if (currentIndex == idx) {
                        [cell.selectBtn cancelSelect];
                    }else{
                        [cell.selectBtn refreshSelectClickNum:idx];
                    }
                }else{
                    [cell.selectBtn refreshSelectClickNum:idx+1];
                }
                break;
            }
        }
    }];
    
    BKIPImagePickerCollectionViewCell * currentSelectCell = nil;
    NSArray * currentDisplayCellArr = [self.collectionView visibleCells];
    for (int i = 0; i < [currentDisplayCellArr count]; i++) {
        BKIPImagePickerCollectionViewCell * cell = currentDisplayCellArr[i];
        if ([imageModel.fileName isEqualToString:cell.model.fileName]) {
            currentSelectCell = cell;
            break;
        }
    }
    
    if (isHave) {
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray removeObjectAtIndex:currentIndex];
    }else {
        if ([[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count] >= [BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect) {
            BKIP_showMessage([NSString stringWithFormat:@"最多只能选择%ld张照片", [BKImagePickerShareManager sharedManager].imagePickerModel.maxSelect]);
            return;
        }
        
        [[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray addObject:imageModel];
        [currentSelectCell.selectBtn selectClickNum:[[BKImagePickerShareManager sharedManager].imagePickerModel.selectImageArray count]];
        
        if (imageModel.loadingProgress != 1) {
            if (imageModel.photoType == BKIPSelectTypeVideo) {
                [[BKImagePickerShareManager sharedManager] getVideoDataWithAsset:imageModel.asset progressHandler:^(double progress, NSError * _Nonnull error, PHImageRequestID imageRequestID) {
                    if (error) {
                        imageModel.loadingProgress = 0;
                    }else {
                        imageModel.loadingProgress = progress;
                    }
                    [[BKImagePickerShareManager sharedManager] updateSelectedImageModel:imageModel];
                } complete:^(AVPlayerItem * _Nonnull playerItem, PHImageRequestID imageRequestID) {
                    if (playerItem) {
                        AVURLAsset * avUrlAsset = (AVURLAsset*)playerItem.asset;
                        imageModel.avURLAsset = avUrlAsset;
                        imageModel.loadingProgress = 1;
                        imageModel.originalFileSize = [[NSData dataWithContentsOfURL:avUrlAsset.URL] length]/1024/1024.0f;
                        imageModel.url = avUrlAsset.URL;
                        
                        [self calculataImageSize];
                        [self refreshBottomNavBtnState];
                    }else {
                        imageModel.loadingProgress = 0;
                        BKIP_showMessage(BKVideoDownloadFailedRemind);
                        //删除选中的自己
                        [self clickSelectImageAction:imageModel currentIndexPath:currentIndexPath];
                    }
                    [[BKImagePickerShareManager sharedManager] updateSelectedImageModel:imageModel];
                }];
            }else {
                [[BKImagePickerShareManager sharedManager] getOriginalImageDataWithAsset:imageModel.asset progressHandler:^(double progress, NSError *error, PHImageRequestID imageRequestID) {
                    if (error) {
                        imageModel.loadingProgress = 0;
                        return;
                    }
                    imageModel.loadingProgress = progress;
                    [[BKImagePickerShareManager sharedManager] updateSelectedImageModel:imageModel];
                } complete:^(NSData *originalImageData, NSURL *url, PHImageRequestID imageRequestID) {
                    if (originalImageData) {
                        imageModel.thumbImageData = [[BKImagePickerShareManager sharedManager] compressImageData:originalImageData];
                        imageModel.originalImageData = originalImageData;
                        imageModel.loadingProgress = 1;
                        imageModel.originalFileSize = (double)originalImageData.length/1024/1024.0f;
                        imageModel.url = url;
                        
                        [self calculataImageSize];
                        [self refreshBottomNavBtnState];
                    }else {
                        imageModel.loadingProgress = 0;
                        BKIP_showMessage(BKOriginalImageDownloadFailedRemind);
                        //删除选中的自己
                        [self clickSelectImageAction:imageModel currentIndexPath:currentIndexPath];
                    }
                    [[BKImagePickerShareManager sharedManager] updateSelectedImageModel:imageModel];
                }];
            }
        }
    }
    [self calculataImageSize];
    [self refreshBottomNavBtnState];
}

@end
