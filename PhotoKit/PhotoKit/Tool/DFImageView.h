//
//  DFImageView.h
//  iOS8
//
//  Created by ongfei on 2018/6/6.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "FLAnimatedImageView.h"

@interface DFImageView : FLAnimatedImageView

- (void)setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;

- (void)setGifImageWithData:(NSData *)gifData;

- (void)clearImage;

@end
