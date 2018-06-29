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

typedef enum : NSUInteger {
    DFPhotoSizeTypeOriginal = 0,    //原始尺寸 对应model里的imageSize
    DFPhotoSizeTypeScaleScreen,     //屏幕比率 对应model里的previewImageSize
    DFPhotoSizeTypeFillScreen      //屏幕填充 对应model里的previewFillImageSize
} DFPhotoSizeType;

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
 通过DFPhotoModel获取对应的image数组
 gif livephoto 都转成了静态图
 @param scale 缩放比率
 */
+ (void)getSelectedImageList:(NSArray<DFPhotoModel *> *)modelList type:(DFPhotoSizeType)type scale:(CGFloat)scale success:(void(^)(NSArray<UIImage *> *imageArr))success failed:(void(^)(void))failed;
/**
 通过DFPhotoModel存入本地临时文件
 type scale 只针对图片 
 */
+ (void)writeSelectModelListToTempPathWithList:(NSArray<DFPhotoModel *> *)modelList type:(DFPhotoSizeType)type scale:(CGFloat)scale success:(void(^)(NSArray<NSURL *> *allURL,NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL))success failed:(void(^)(void))failed;
/**
 gif图
 */
+ (UIImage *)animatedGIFWithData:(NSData *)data;
//相册英文名转中文
+ (NSString *)transFormPhotoTitle:(NSString *)englishName;

+ (BOOL)clearTempImageCache;

@end
