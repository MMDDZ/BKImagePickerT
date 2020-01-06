//
//  ViewController.m
//  BKImagePickerDemo
//
//  Created by zhaolin on 2019/8/24.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "ViewController.h"
#import <BKImagePicker/BKImagePicker.h>

/**
 是否是iPhone X系列
 */
NS_INLINE CGFloat isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,copy) NSArray * titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @[@"图库"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat y = isIPhoneXSeries() ? 44 : 20;
    self.tableView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UITableView

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.item) {
        case 0:
        {
            [[BKImagePicker sharedManager] showImageAlbumWithDisplayType:BKIPDisplayTypeDefault maxSelect:6 isHaveOriginal:YES complete:^(PHAsset * _Nonnull asset, UIImage * _Nonnull image, NSData * _Nonnull data, NSURL * _Nonnull url, BKIPSelectType selectType) {
                NSLog(@"asset:%@, image:%@, dataLength:%ld, url:%@, selectType:%ld", asset, image, [data length], url, selectType);
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
