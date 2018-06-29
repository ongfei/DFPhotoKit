//
//  DFImageView.m
//  iOS8
//
//  Created by ongfei on 2018/6/6.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFImageView.h"
#import "FLAnimatedImage.h"
#import <UIImageView+WebCache.h>
#import <NSData+ImageContentType.h>

@implementation DFImageView

- (void)setImageWithURL:(nullable NSURL *)url
       placeholderImage:(nullable UIImage *)placeholder {

    self.image = placeholder;
    self.animatedImage = nil;
    if ([[SDImageCache sharedImageCache] diskImageDataExistsWithKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]]) {
        NSString *path = [[SDImageCache sharedImageCache] defaultCachePathForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfFile:path];
            SDImageFormat format = [NSData sd_imageFormatForImageData:data];
            if (format == SDImageFormatGIF) {
                [self setGifImageWithData:data];
            }else {
                self.image = [UIImage imageWithContentsOfFile:path];
                self.animatedImage = nil;
            }
        });
    }else {
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SDImageFormat format = [NSData sd_imageFormatForImageData:data];
                if (format == SDImageFormatGIF) {
                    [self setGifImageWithData:data];
                }else {
                    self.image = image;
                    self.animatedImage = nil;
                }
            });
        }];
    }
}

- (void)setGifImageWithData:(NSData *)gifData {

    self.image = nil;
    self.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
}


- (void)clearImage {
    self.image = nil;
    self.animatedImage = nil;
}

@end
