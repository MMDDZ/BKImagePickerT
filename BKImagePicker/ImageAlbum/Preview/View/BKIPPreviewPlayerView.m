//
//  BKIPPreviewPlayerView.m
//  BKImagePicker
//
//  Created by zhaolin on 2020/1/4.
//  Copyright © 2020 BIKE. All rights reserved.
//

#import "BKIPPreviewPlayerView.h"

@interface BKIPPreviewPlayerView()

@property (nonatomic,assign) PHImageRequestID requestID;//当前下载的ID

@property (nonatomic,strong) BKIPImageView * coverImageView;//封面
@property (nonatomic,strong) UIProgressView * progress;//播放进度条(没加载显示)
@property (nonatomic,assign) id timeObserver;

@property (nonatomic,strong) UIView * playerView;
@property (nonatomic,strong) AVPlayer * player;
@property (nonatomic,strong) AVPlayerLayer * playerLayer;

@end

@implementation BKIPPreviewPlayerView
@synthesize imageModel = _imageModel;
@synthesize coverImage = _coverImage;

#pragma mark - 播放/停止

-(void)playImageModel:(BKImagePickerImageModel*)imageModel coverImage:(UIImage*)coverImage
{
    _imageModel = imageModel;
    _coverImage = coverImage;
    
    [self stopPlay];
    
    self.coverImageView.image = _coverImage;
    self.coverImageView.hidden = NO;
    
    self.requestID = [[BKImagePickerShareManager sharedManager] getVideoDataWithAsset:_imageModel.asset progressHandler:^(double progress, NSError *error, PHImageRequestID imageRequestID) {
        if (error) {
            [self bk_hideLoadLayer];
            return;
        }
        [self bk_showLoadLayerWithDownLoadProgress:progress];
        
    } complete:^(AVPlayerItem *playerItem, PHImageRequestID imageRequestID) {
        [self bk_hideLoadLayer];
        if (playerItem) {
            
            self.player = [AVPlayer playerWithPlayerItem:playerItem];
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            [self.playerView.layer addSublayer:self.playerLayer];
            [self.player play];
            
            [self layoutSubviews];
            
            AVPlayerItem * playerItem = self.player.currentItem;
            BKIP_WEAK_SELF(self);
            self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                weakSelf.coverImageView.image = nil;
                weakSelf.coverImageView.hidden = YES;
                if (weakSelf.progress) {
                    float current = CMTimeGetSeconds(time);
                    float total = CMTimeGetSeconds([playerItem duration]);
                    if (current) {
                        [weakSelf.progress setProgress:(current/total) animated:YES];
                    }
                }
            }];
        }else {
            BKIP_showMessage(BKVideoDownloadFailedRemind);
        }
    }];
}

-(void)stopPlay
{
    self.coverImageView.image = nil;
    self.coverImageView.hidden = YES;
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    [self.progress setProgress:0];
    [[BKImagePickerShareManager sharedManager] cancelImageRequest:self.requestID];
}

/// 内部停止播放方法
-(void)privateStopPlay
{
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self stopPlay];
    if (self.playFinishedCallBack) {
        self.playFinishedCallBack();
    }
}

#pragma mark - init

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self initUI];
        [self addNotifications];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self initUI];
        [self addNotifications];
    }
    return self;
}

-(void)dealloc
{
    [self removeNotifications];
}

#pragma mark - layoutSubviews

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.playerView.frame = self.bounds;
    self.playerLayer.frame = self.playerView.bounds;
    self.coverImageView.frame = self.bounds;
}

#pragma mark - 通知

-(void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinishedNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)willResignActiveNotification:(NSNotification*)notification
{
    [self privateStopPlay];
}

-(void)playbackFinishedNotification:(NSNotification*)notification
{
    [self privateStopPlay];
}


#pragma mark - initUI

-(void)initUI
{
    [self addSubview:self.playerView];
    [self addSubview:self.coverImageView];
}

#pragma mark - playerView

-(UIView*)playerView
{
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        _playerView.backgroundColor = [UIColor blackColor];
    }
    return _playerView;
}

#pragma mark - coverImageView

-(BKIPImageView*)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[BKIPImageView alloc] init];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

#pragma mark - 进度条

-(UIProgressView*)progress
{
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
    }
    return _progress;
}

@end
