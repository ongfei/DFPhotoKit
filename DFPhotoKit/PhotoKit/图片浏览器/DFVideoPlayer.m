//
//  DFVideoPlayer.m
//  iOS8
//
//  Created by ongfei on 2018/6/14.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFVideoPlayer.h"

@interface DFVideoPlayer ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end
@implementation DFVideoPlayer

static DFVideoPlayer *instance = nil;
//+ (instancetype)shareInstance {
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//    
//    return instance;
//}

- (void)playWithUrl:(NSURL *)url superView:(UIView *)view frame:(CGRect)frame {
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    self.playItem = item;
    [self.player replaceCurrentItemWithPlayerItem:item];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer = playerLayer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = frame;
    
    [view.layer insertSublayer:playerLayer atIndex:0];
    
    [self.player play];
}
- (void)playWithItem:(AVPlayerItem *)item superView:(UIView *)view frame:(CGRect)frame {
    [self.player replaceCurrentItemWithPlayerItem:item];
    self.playItem = item;
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer = playerLayer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = frame;
    
    [view.layer insertSublayer:playerLayer atIndex:0];
    
    [self.player play];
}

- (void)stopPlay {
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    [self.player pause];
    self.player = nil;

}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

@end
