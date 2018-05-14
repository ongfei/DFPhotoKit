//
//  DFPhotoKitDeal.h
//  iOS8
//
//  Created by ongfei on 2018/5/4.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "DFPhotoAlbumModel.h"
#import "DFPhotoModel.h"

@interface DFPhotoKitDeal : NSObject
/**
 通过相册model获取image
 */
+ (PHImageRequestID)getImageWithAlbumModel:(DFPhotoAlbumModel *)model size:(CGSize)size completion:(void (^)(UIImage *image, DFPhotoAlbumModel *model))completion;
/**
 根据PHAsset获取图片data
 */
+ (PHImageRequestID)getImageData:(PHAsset *)asset completion:(void(^)(NSData *imageData, UIImageOrientation orientation))completion error:(void(^)(void))error;
/**
 根据PHAsset获取图片信息
 执行一次
 */
+ (PHImageRequestID)getHighQualityFormatPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion error:(void(^)(NSDictionary *info))error;
/**
 根据PHAsset获取图片信息
 执行多次
 */
+ (PHImageRequestID)getPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion;
/**
 根据PHAsset获取LivePhoto
 */
+ (PHImageRequestID)getLivePhotoForAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(PHLivePhoto *livePhoto))completion failed:(void(^)(void))failed  API_AVAILABLE(ios(9.1));
/**
 根据PHAsset获取AVAsset
 */
+ (PHImageRequestID)getAVAssetWithPHAsset:(PHAsset *)phAsset completion:(void(^)(AVAsset *asset))completion failed:(void(^)(void))failed;
/**
 根据PHAsset获取PlayerItem
 */
+ (PHImageRequestID)getPlayerItemWithPHAsset:(PHAsset *)asset completion:(void(^)(AVPlayerItem *playerItem))completion failed:(void(^)(void))failed;

/**
 保存图片到相册

 @param albumName 相册名 传nil或者@""保存到系统相册 否则创建自定义相册并保存
 @param photo 要保存的image
 @param saveState 保存状态
 */
+ (void)savePhotoToCustomAlbumWithName:(NSString *)albumName photo:(UIImage *)photo state:(void(^)(BOOL state))saveState;

/**
 gif图
 */
+ (UIImage *)animatedGIFWithData:(NSData *)data;
//相册英文名转中文
+ (NSString *)transFormPhotoTitle:(NSString *)englishName;
@end
