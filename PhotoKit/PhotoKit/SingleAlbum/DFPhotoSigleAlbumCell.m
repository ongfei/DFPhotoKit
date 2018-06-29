//
//  DFPhotoSigleAlbumCell.m
//  iOS8
//
//  Created by ongfei on 2018/6/1.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPhotoSigleAlbumCell.h"
#import "DFPhotoKitDeal.h"
#import <Masonry.h>
#import "DFImageView.h"

@interface DFPhotoSigleAlbumCell ()

@property (nonatomic, strong) DFImageView *imageV;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIImageView *livePhotoSign;
@property (nonatomic, strong) UIImageView *gifSign;
@property (nonatomic, strong) UILabel *videoTimeL;

@end

@implementation DFPhotoSigleAlbumCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageV = [[DFImageView alloc] init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageV setClipsToBounds:YES];
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
     
        self.livePhotoSign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_live_photo_open_only_icon"]];
        self.livePhotoSign.contentMode = UIViewContentModeScaleAspectFill;
        [self.livePhotoSign setClipsToBounds:YES];
        self.livePhotoSign.hidden = YES;
        [self.contentView addSubview:self.livePhotoSign];
        [self.livePhotoSign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(5);
            make.width.height.mas_equalTo(20);
        }];
        
        self.gifSign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        self.gifSign.hidden = YES;
        [self.contentView addSubview:self.gifSign];
        [self.gifSign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30);
        }];
        
        self.videoTimeL = [[UILabel alloc] init];
        [self.contentView addSubview:self.videoTimeL];
        self.videoTimeL.font = [UIFont systemFontOfSize:11 weight:0.7];
        self.videoTimeL.textAlignment = NSTextAlignmentRight;
        self.videoTimeL.textColor = [UIColor whiteColor];
        [self.videoTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.imageV);
        }];
        
        self.shadeView = [[UIView alloc] init];
        [self.contentView addSubview:self.shadeView];
        [self.shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        self.shadeView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
        self.shadeView.hidden = YES;
        self.shadeView.userInteractionEnabled = NO;
        
        self.selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.contentView addSubview:self.selectBtn];
        [self.selectBtn setImage:[UIImage imageNamed:@"compose_photo_preview_default2"] forState:(UIControlStateNormal)];
        [self.selectBtn setImage:[UIImage imageNamed:@"compose_photo_preview_right2"] forState:(UIControlStateSelected)];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.width.height.mas_equalTo(30);
        }];
        [self.selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    return self;
}

- (void)setPhotoM:(DFPhotoModel *)photoM {
    _photoM = photoM;
    
    self.gifSign.hidden = YES;
    self.livePhotoSign.hidden = YES;
    self.videoTimeL.text = @"";

    switch (photoM.type) {
        case DFPhotoModelMediaTypeLivePhoto:
            self.livePhotoSign.hidden = NO;
            break;
        case DFPhotoModelMediaTypePhotoGif:
            self.gifSign.hidden = NO;
            break;
        case DFPhotoModelMediaTypeVideo:
            self.videoTimeL.text = photoM.videoDuration;
            break;
        default:
            break;
    }
    
    [DFPhotoKitDeal getPhotoForPHAsset:photoM.asset size:CGSizeMake((([UIScreen mainScreen].bounds.size.width - 25) / 4)*1.5, (([UIScreen mainScreen].bounds.size.width - 25) / 4)*1.5) completion:^(UIImage *image, NSDictionary *info) {
        self.imageV.image = image;
    }];
    
}

- (void)selectBtnClick {
    if (self.selectBlock) {
        BOOL canChange = self.selectBlock(!self.selectBtn.selected, self.photoM);
        if (canChange) {
            self.selectBtn.selected = !self.selectBtn.selected;
            self.shadeView.hidden = !self.selectBtn.selected;
        }
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        self.selectBtn.selected = YES;
        self.shadeView.hidden = NO;
    }else {
        self.selectBtn.selected = NO;
        self.shadeView.hidden = YES;
    }
}
@end
