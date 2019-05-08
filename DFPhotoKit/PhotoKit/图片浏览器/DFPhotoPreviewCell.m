//
//  DFPhotoPreviewCell.m
//  iOS8
//
//  Created by ongfei on 2018/5/9.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPhotoPreviewCell.h"
#import <Masonry.h>
#import "DFVideoPlayer.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface DFPhotoPreviewCell ()<UIScrollViewDelegate>


@end

@implementation DFPhotoPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.scrollBg = [[UIScrollView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.scrollBg];
        
        self.scrollBg.contentSize = CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height);
        self.scrollBg.delegate = self;
        self.scrollBg.maximumZoomScale = 1.5;
        self.scrollBg.minimumZoomScale = 0.5;

        
        self.imageV = [[DFImageView alloc] init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageV setClipsToBounds:YES];
        [self.scrollBg addSubview:self.imageV];
        self.imageV.center = self.scrollBg.center;
        
        [self.scrollBg addSubview:self.livePhoto];
        self.livePhoto.center = self.scrollBg.center;
        
        self.imageV.hidden = YES;
        self.livePhoto.hidden = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self.scrollBg addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.scrollBg addGestureRecognizer:doubleTap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
        
    }
    
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTap) {
        self.singleTap();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (self.photoM == nil) {
        return;
    }
    if (self.scrollBg.zoomScale > 1.0) {
        
        [self.scrollBg setZoomScale:1.0 animated:YES];
        
    } else {
        
        CGFloat width = self.contentView.frame.size.width;
        CGFloat height = self.contentView.frame.size.height;
        if (self.photoM.direction == DFPhotoModelalDirectionHorizontal) {
            self.scrollBg.maximumZoomScale = height / self.photoM.previewViewSize.height;
        }else {
            self.scrollBg.maximumZoomScale = width / self.photoM.previewViewSize.width;
        }
        if (height == self.photoM.previewViewSize.height && width == self.photoM.previewViewSize.width) {
            self.scrollBg.maximumZoomScale = 2.0;
        }
        if (self.scrollBg.maximumZoomScale < 1.5) {
            self.scrollBg.maximumZoomScale = 1.5;
        }
        
        CGPoint touchPoint;
        if (self.photoM.type == DFPhotoModelMediaTypeLivePhoto) {
            touchPoint = [tap locationInView:self.livePhoto];
        }else {
            touchPoint = [tap locationInView:self.imageV];
        }
        CGFloat newZoomScale = self.scrollBg.maximumZoomScale;
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        
        [self.scrollBg zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        
        if (self.photoM.type == DFPhotoModelMediaTypePhoto) {
            [DFPhotoKitDeal getHighQualityFormatPhotoForPHAsset:self.photoM.asset size:CGSizeMake(self.photoM.asset.pixelWidth, self.photoM.asset.pixelHeight) completion:^(UIImage *image, NSDictionary *info) {
                self.imageV.image = image;
            } error:^(NSDictionary *info) {
                
            }];
        }
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)setPhotoM:(DFPhotoModel *)photoM {
    _photoM = photoM;
    self.imageV.hidden = YES;
    self.livePhoto.hidden = YES;

    [self stopEven];

    self.imageV.frame = CGRectMake(0, 0, photoM.previewViewFillSize.width, photoM.previewViewFillSize.height);
    self.livePhoto.frame = CGRectMake(0, 0, photoM.previewViewFillSize.width, photoM.previewViewFillSize.height);
    self.livePhoto.center = self.scrollBg.center;
    self.imageV.center = self.scrollBg.center;

    
    switch (photoM.type) {
        case DFPhotoModelMediaTypePhoto: {
            self.imageV.hidden = NO;
            
            [DFPhotoKitDeal getPhotoForPHAsset:photoM.asset size:photoM.previewImageSize completion:^(UIImage *image, NSDictionary *info) {

                self.imageV.image = image;

            }];
        }
            break;
        case DFPhotoModelMediaTypeLivePhoto: {
            self.livePhoto.hidden = NO;
            
            [DFPhotoKitDeal getLivePhotoForAsset:photoM.asset size:photoM.previewFillImageSize completion:^(PHLivePhoto *livePhoto) {
               
                self.livePhoto.livePhoto = livePhoto;
                
            } failed:^{
                NSLog(@"加载失败");
            }];
        }
            break;
        case DFPhotoModelMediaTypePhotoGif: {
            self.imageV.hidden = NO;
            
            [DFPhotoKitDeal getImageData:photoM.asset completion:^(NSData *imageData, UIImageOrientation orientation) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [self.imageV setGifImageWithData:imageData];
                });
                
            } error:^{
                NSLog(@"加载失败");
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)stopEven {
    [self resetScale];
    self.scrollBg.scrollEnabled = YES;

}
- (void)resetScale {
    [self.scrollBg setZoomScale:1.0 animated:NO];
}

- (PHLivePhotoView *)livePhoto {
    if (!_livePhoto) {
        _livePhoto = [[PHLivePhotoView alloc] init];
        _livePhoto.clipsToBounds = YES;
        _livePhoto.contentMode = UIViewContentModeScaleAspectFill;
//        _livePhoto.delegate = self;
    }
    return _livePhoto;
}

#pragma mark -  ----------delegate----------

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.photoM.type == DFPhotoModelMediaTypeLivePhoto) {
        return self.livePhoto;
    }
    return self.imageV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    if (self.photoM.type == DFPhotoModelMediaTypeLivePhoto) {
        self.livePhoto.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }else {
        self.imageV.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }
}

@end
