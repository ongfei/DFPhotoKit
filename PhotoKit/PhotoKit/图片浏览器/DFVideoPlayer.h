//
//  DFVideoPlayer.h
//  iOS8
//
//  Created by ongfei on 2018/6/14.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface DFVideoPlayer : NSObject

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playItem;


//+ (instancetype)shareInstance;

- (void)playWithUrl:(NSURL *)url superView:(UIView *)view frame:(CGRect)frame;
- (void)playWithItem:(AVPlayerItem *)item superView:(UIView *)view frame:(CGRect)frame;

- (void)stopPlay;


@end
