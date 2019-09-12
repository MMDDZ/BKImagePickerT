//
//  BKIPImageAlbumListViewController.m
//  BKImagePicker
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "BKIPImageAlbumListViewController.h"
#import "BKIPImagePickerViewController.h"
#import "BKImagePickerHeader.h"
#import "BKIPImageAlbumListModel.h"
#import "BKIPImageAlbumListTableViewCell.h"
#import "BKImagePicker.h"

@interface BKIPImageAlbumListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray<BKIPImageAlbumListModel*> * imageClassArray;

@end

@implementation BKIPImageAlbumListViewController

#pragma mark - 获取数据

-(NSMutableArray<BKIPImageAlbumListModel *> *)imageClassArray
{
    if (!_imageClassArray) {
        _imageClassArray = [NSMutableArray array];
    }
    return _imageClassArray;
}

-(void)getAllImageClassData
{
    //系统的相簿
    PHFetchResult * smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [self getSingleAlbum:smartAlbums];
    
    //用户自己创建的相簿
    PHFetchResult * userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [self getSingleAlbum:userAlbums];
}

-(void)getSingleAlbum:(PHFetchResult*)fetchResult
{
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection * collection = obj;
        //创建数据model
        BKIPImageAlbumListModel * model = [[BKIPImageAlbumListModel alloc] init];
        // 获取所有资源的集合按照创建时间倒序排列
        PHFetchOptions * fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d || mediaType = %d", PHAssetMediaTypeImage, PHAssetMediaTypeVideo];
        //获取该相册下的所有资源
        PHFetchResult<PHAsset *> *assets  = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
        if ([assets count] > 0) {
            __block NSInteger coverIndex = 0;
            __block NSInteger assetsCount = [assets count];
            [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                switch ([BKImagePickerShareManager sharedManager].imagePickerModel.displayType) {
                    case BKIPDisplayTypeDefault:
                        break;
                    case BKIPDisplayTypeImageAndGif:
                    {
                        if (obj.mediaType == PHAssetMediaTypeVideo) {
                            assetsCount--;
                            if (idx == coverIndex) {
                                coverIndex++;
                            }
                        }
                    }
                        break;
                    case BKIPDisplayTypeImageAndVideo:
                    {
                        NSString * fileName = [[obj valueForKey:@"filename"] uppercaseString];
                        if ([fileName rangeOfString:@"GIF"].location != NSNotFound) {
                            assetsCount--;
                            if (idx == coverIndex) {
                                coverIndex++;
                            }
                        }
                    }
                        break;
                    case BKIPDisplayTypeImage:
                    {
                        if (obj.mediaType == PHAssetMediaTypeImage) {
                            NSString * fileName = [[obj valueForKey:@"filename"] uppercaseString];
                            if ([fileName rangeOfString:@"GIF"].location != NSNotFound) {
                                assetsCount--;
                                if (idx == coverIndex) {
                                    coverIndex++;
                                }
                            }
                        }else {
                            assetsCount--;
                            if (idx == coverIndex) {
                                coverIndex++;
                            }
                        }
                    }
                        break;
                }
            }];
            
            if (assetsCount > 0) {
                model.albumName = collection.localizedTitle;
                model.albumImageCount = assetsCount;
                model.coverAsset = assets[coverIndex];
                //相机胶卷放在第一位
                if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                    [self.imageClassArray insertObject:model atIndex:0];
                }else {
                    [self.imageClassArray addObject:model];
                }
            }
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self getAllImageClassData];
    }
    return self;
}

#pragma mark - viewDidLoad

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTopNav];
    [self.view addSubview:self.tableView];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0, self.topNavViewHeight, self.view.bk_width, self.view.bk_height - self.topNavViewHeight - self.bottomNavViewHeight);
}

#pragma mark - initTopNav

-(void)initTopNav
{
    self.title = @"相册";
    
    self.leftNavBtns = @[];
    
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

#pragma mark - UITableView

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = self.view.bk_height / 10;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[BKIPImageAlbumListTableViewCell class] forCellReuseIdentifier:kBKIPImageAlbumListTableViewCellID];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.imageClassArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BKIPImageAlbumListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kBKIPImageAlbumListTableViewCellID];
    BKIP_WEAK_SELF(self);
    [cell setGetThumbCoverImageCallBack:^(UIImage * _Nonnull coverImage, NSIndexPath * _Nonnull currentIndexPath) {
        BKIPImageAlbumListModel * model = weakSelf.imageClassArray[currentIndexPath.row];
        model.coverImage = coverImage;
        [weakSelf.imageClassArray replaceObjectAtIndex:currentIndexPath.row withObject:model];
    }];
    
    BKIPImageAlbumListModel * model = self.imageClassArray[indexPath.row];
    [cell setModel:model indexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BKIPImageAlbumListModel * model = self.imageClassArray[indexPath.row];
    
    BKIPImagePickerViewController * vc = [[BKIPImagePickerViewController alloc] init];
    vc.title = model.albumName;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
