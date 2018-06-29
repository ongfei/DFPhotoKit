//
//  DFPhotoModel.h
//  iOS8
//
//  Created by ongfei on 2018/5/7.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    DFPhotoModelMediaTypePhoto = 0, // 照片
    DFPhotoModelMediaTypeLivePhoto, // LivePhoto
    DFPhotoModelMediaTypePhotoGif,  // gif图
    DFPhotoModelMediaTypeVideo,     // 视频
    DFPhotoModelMediaTypeOther      //未知
} DFPhotoModelMediaType;

typedef enum : NSUInteger {
    DFPhotoModelalDirectionHorizontal = 0,   // 原始图为横屏
    DFPhotoModelalDirectionVertical,         // 原始图为竖屏
} DFPhotoModelalDirection;


@interface DFPhotoModel : NSObject
/**
 下载iCloud的请求id
 */
@property (nonatomic, assign) PHImageRequestID iCloudRequestID;
/**
 照片PHAsset对象
 */
@property (nonatomic, strong) PHAsset *asset;
/**
 照片类型
 */
@property (nonatomic, assign) DFPhotoModelMediaType type;
@property (nonatomic, strong) NSString *videoDuration;
/**
 照片原始宽高像素值
 */
@property (nonatomic, assign) CGSize imageSize;
/**
 照片原始方向
 */
@property (nonatomic, assign) DFPhotoModelalDirection direction;
/**
 是否是长图
 */
@property (nonatomic, assign) BOOL isPanorama;
/**
 按屏幕比例缩小之后的宽高
 用于view的大小
 */
@property (nonatomic, assign) CGSize previewViewSize;
/**
 按屏幕比例填充之后的宽高
 用于view的大小
 */
@property (nonatomic, assign) CGSize previewViewFillSize;
/**
 按屏幕比例缩小之后的宽高
 高清image的 size
 */
@property (nonatomic, assign) CGSize previewImageSize;
/**
 填充整个屏幕的size
 */
@property (nonatomic, assign) CGSize previewFillImageSize;

@end
