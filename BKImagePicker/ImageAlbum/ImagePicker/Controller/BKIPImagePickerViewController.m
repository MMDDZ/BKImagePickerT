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

@interface BKIPImagePickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionView;

/**
 资源数组
 */
@property (nonatomic,strong) NSMutableArray<BKImagePickerImageModel*> * assetListArray;
/**
 list数据(不包括视频)
 */
@property (nonatomic,strong) NSMutableArray<BKImagePickerImageModel*> * imageListArray;

/**
 该相簿中所有照片和视频总数
 */
@property (nonatomic,assign) NSUInteger allAssestNum;
/**
 该相簿中除gif外所有其他类型照片总数
 */
@property (nonatomic,assign) NSUInteger allImageNum;
/**
 该相簿中所有GIF照片总数
 */
@property (nonatomic,assign) NSUInteger allGifImageNum;
/**
 该相簿中所有视频总数
 */
@property (nonatomic,assign) NSUInteger allVideoNum;

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

-(NSMutableArray<BKImagePickerImageModel *> *)imageListArray
{
    if (!_imageListArray) {
        _imageListArray = [NSMutableArray array];
    }
    return _imageListArray;
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
                    [self.imageListArray addObject:model];
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
//    if ([BKImagePicker sharedManager].imageManageModel.max_select != 1) {
//        [self initBottomNav];
//    }
    
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
    [rightNavBtn addTarget:self action:@selector(rightNavBtnClick)];
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
//    BKImageModel * model = self.listArray[indexPath.item];
//
//    if (model.asset.mediaType == PHAssetMediaTypeImage) {
//
//        //当裁剪比例不为0时 进入裁剪状态
//        if ([BKImagePicker sharedManager].imageManageModel.clipSize_width_height_ratio != 0) {
//
//            [[BKImagePicker sharedManager] getOriginalImageWithAsset:model.asset complete:^(UIImage *originalImage) {
//                BKEditImageViewController * vc = [[BKEditImageViewController alloc] init];
//                vc.editImageArr = @[originalImage];
//                vc.fromModule = BKEditImageFromModulePhotoAlbum;
//                [self.navigationController pushViewController:vc animated:YES];
//            }];
//
//        }else{
//            BKImagePickerCollectionViewCell * cell = (BKImagePickerCollectionViewCell*)[self.albumCollectionView cellForItemAtIndexPath:indexPath];
//            if (!cell) {
//                [self.albumCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    BKImagePickerCollectionViewCell * cell = (BKImagePickerCollectionViewCell*)[self.albumCollectionView cellForItemAtIndexPath:indexPath];
//                    [self previewWithCell:cell imageListArray:self.imageListArray tapModel:model];
//                });
//            }else{
//                [self previewWithCell:cell imageListArray:self.imageListArray tapModel:model];
//            }
//        }
//
//    }else{
//        if ([[BKImagePicker sharedManager].imageManageModel.selectImageArray count] > 0) {
//            [self.view bk_showRemind:BKCanNotSelectBothTheImageAndVideoRemind];
//            return;
//        }
//
//        BKVideoPreviewViewController * vc = [[BKVideoPreviewViewController alloc]init];
//        vc.tapVideoModel = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

//-(void)previewWithCell:(BKImagePickerCollectionViewCell*)cell imageListArray:(NSArray*)imageListArray tapModel:(BKImageModel*)tapModel
//{
//    if (!cell.photoImageView.image && cell) {
//        return;
//    }
//
//    BKImagePreviewViewController * vc = [[BKImagePreviewViewController alloc]init];
//    vc.delegate = self;
//    vc.tapImageView = cell.photoImageView;
//    vc.imageListArray = [imageListArray copy];
//    vc.tapImageModel = tapModel;
//    [vc showInNav:self.navigationController];
//}

@end
