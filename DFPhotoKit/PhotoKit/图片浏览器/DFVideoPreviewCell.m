//
//  DFVideoPreviewCell.m
//  iOS8
//
//  Created by ongfei on 2018/6/14.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFVideoPreviewCell.h"
#import "DFVideoPlayer.h"

@interface DFVideoPreviewCell ()

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIView *playView;
@property (nonatomic, strong) DFVideoPlayer *videoPlayer;

@end
@implementation DFVideoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.imageV = [[DFImageView alloc] init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageV setClipsToBounds:YES];
        [self.contentView addSubview:self.imageV];
        self.imageV.center = self.contentView.center;
        
        self.playView = [UIView new];
        [self.contentView addSubview:self.playView];
        self.playView.hidden = YES;
        
        self.playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.contentView addSubview:self.playBtn];
        self.playBtn.frame = CGRectMake(0, 0, 80, 80);
        self.playBtn.center = self.imageV.center;
        [self.playBtn setImage:[UIImage imageNamed:@"common_icon_play"] forState:(UIControlStateNormal)];
        [self.playBtn setImage:[UIImage imageNamed:@"uls_icon_bro_playback_pause_n"] forState:(UIControlStateSelected)];
        [self.playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self.contentView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    self.playBtn.hidden = !self.playBtn.hidden;
    if (self.videoPlayer.player.currentTime.value == self.videoPlayer.player.currentItem.duration.value) {
        self.playBtn.selected = NO;
    }
    if (self.singleTap) {
        self.singleTap();
    }
}
- (void)displayImg {
    self.playView.hidden = YES;
    self.playBtn.selected = NO;
    self.playBtn.hidden = NO;
    [self.videoPlayer stopPlay];
}
#pragma mark -  ----------video----------

- (void)setVideoM:(DFPhotoModel *)videoM {
    _videoM = videoM;
    
    self.imageV.frame = CGRectMake(0, 0, videoM.previewViewFillSize.width, videoM.previewViewFillSize.height);
    self.imageV.center = self.contentView.center;
    self.playBtn.center = self.imageV.center;
    self.playView.frame = self.imageV.frame;
    self.playView.center = self.imageV.center;
    
    [DFPhotoKitDeal getPhotoForPHAsset:videoM.asset size:videoM.previewImageSize completion:^(UIImage *image, NSDictionary *info) {
        self.imageV.image = image;
    }];
}

- (void)playBtnClick {
    
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected == YES) {
        
        if (self.videoPlayer.player.currentTime.value != 0) {
            
            if (self.videoPlayer.player.currentTime.value == self.videoPlayer.player.currentItem.duration.value) {
                
                [self.videoPlayer.player seekToTime:CMTimeMake(0, 1)];
            }
            
            self.playView.hidden = NO;
            self.playBtn.hidden = YES;
            if (self.singleTap) {
                self.singleTap();
            }
            [self.videoPlayer.player play];

        }else {
            __block __weak typeof(self) weakSelf = self;
            [DFPhotoKitDeal getPlayerItemWithPHAsset:self.videoM.asset completion:^(AVPlayerItem *playerItem) {
                
                weakSelf.playView.hidden = NO;
                weakSelf.playBtn.hidden = YES;
                
                if (weakSelf.singleTap) {
                    weakSelf.singleTap();
                }
                
                [weakSelf.videoPlayer playWithItem:playerItem superView:self.playView frame:CGRectMake(0, 0, weakSelf.imageV.frame.size.width, weakSelf.imageV.frame.size.height)];
                
            } failed:^{
                
            }];
        }
    }else {
        self.playBtn.hidden = NO;
        [self.videoPlayer.player pause];
    }
}

- (DFVideoPlayer *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[DFVideoPlayer alloc] init];
    }
    return _videoPlayer;
}

- (void)dealloc {
    self.videoPlayer = nil;
}

@end
