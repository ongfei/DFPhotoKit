//
//  DFPhotoModel.m
//  iOS8
//
//  Created by ongfei on 2018/5/7.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPhotoModel.h"

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kNavigationBarHeight (kDevice_Is_iPhoneX ? 88 : 64)
#define kBottomMargin (kDevice_Is_iPhoneX ? 34 : 0)
#define kTopMargin (kDevice_Is_iPhoneX ? 44 : 0)

@implementation DFPhotoModel

- (DFPhotoModelalDirection)direction {
    if (self.asset) {
//        if (self.asset.pixelWidth >= self.asset.pixelHeight) {
//            _direction = DFPhotoModelalDirectionHorizontal;
//        }else if (self.asset.pixelWidth < self.asset.pixelHeight) {
//            _direction = DFPhotoModelalDirectionVertical;
//        }
        CGFloat rate = self.asset.pixelHeight / self.asset.pixelWidth;
        CGFloat screenRate = 16.0/9.0;
        if (rate > screenRate) {
            _direction = DFPhotoModelalDirectionVertical;
        }else {
            _direction = DFPhotoModelalDirectionHorizontal;
        }
    }
    return _direction;
}

- (CGSize)imageSize {
    if (_imageSize.width == 0 || _imageSize.height == 0) {
        if (self.asset) {
            if (self.asset.pixelWidth == 0 || self.asset.pixelHeight == 0) {
                _imageSize = CGSizeMake(200, 200);
            }else {
                _imageSize = CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
            }
        }else {
            _imageSize = CGSizeMake(200, 200);
        }
    }
    return _imageSize;
}

- (CGSize)previewViewSize {
    if (_previewViewSize.width == 0 || _previewViewSize.height == 0) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat w = 0;
        CGFloat h = 0;
        //像素转屏幕
        CGFloat imgWidth = self.imageSize.width / 2.0;
        CGFloat imgHeight = self.imageSize.height / 2.0;
        
        if (self.direction == DFPhotoModelalDirectionHorizontal) {
//            横屏
            if (imgWidth > width) {
                w = width;
                h = (width / imgWidth) * imgHeight;
            }else {
                w = imgWidth;
                h = imgHeight;
            }
            
        }else {
            if (imgHeight > height) {
                h = height;
                w = (height / imgHeight) * imgWidth;
            }else {
                h = imgHeight;
                w = imgWidth;
            }
        }
        
        if (h > height + 20) {
            h = height;
        }
        _previewViewSize = CGSizeMake(w, h);
        
    }
    
    return _previewViewSize;
}
- (CGSize)previewImageSize {
    if (_previewImageSize.width == 0 || _previewImageSize.height == 0) {

        if (self.direction == DFPhotoModelalDirectionHorizontal) {
            _previewImageSize = CGSizeMake(self.previewViewSize.height * 2.0, self.previewViewSize.width * 2.0);
        }else {
            _previewImageSize = CGSizeMake(self.previewViewSize.width * 2.0, self.previewViewSize.height * 2.0);
        }
    }
    
    return _previewImageSize;
}

- (CGSize)previewFillImageSize {
    if (_previewFillImageSize.width == 0 || _previewFillImageSize.height == 0) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat w = 0;
        CGFloat h = 0;
        //屏幕转像素
        CGFloat imgWidth = self.imageSize.width * 2.0;
        CGFloat imgHeight = self.imageSize.height * 2.0;
        
        if (self.direction == DFPhotoModelalDirectionHorizontal) {
            w = (height / imgHeight) * imgWidth;
            _previewFillImageSize = CGSizeMake(height, w);
        }else {
            h = (width / imgWidth) * imgHeight;
            _previewFillImageSize = CGSizeMake(width, h);
        }
    }
    return _previewFillImageSize;
}

- (BOOL)isPanorama {
    
    CGFloat hwRate = self.asset.pixelHeight / self.asset.pixelWidth;
    CGFloat whRate = self.asset.pixelWidth / self.asset.pixelHeight;
    CGFloat screenRate = 16.0/9.0;
    
    if (hwRate > screenRate || whRate > screenRate) {
        return YES;
    }else {
        return NO;
    }
}
@end
