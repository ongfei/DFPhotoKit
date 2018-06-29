//
//  DFPhotoKitManager.h
//  iOS8
//
//  Created by ongfei on 2018/5/4.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "DFPhotoAlbumModel.h"
#import "DFPhotoKitDeal.h"

typedef enum : NSUInteger {
    DFPhotoKitManagerSelectedTypePhotoAndVideo,     // 图片和视频一起显示
    DFPhotoKitManagerSelectedTypePhoto,        // 只显示图片
    DFPhotoKitManagerSelectedTypeVideo,        // 只显示视频
} DFPhotoKitManagerSelectedType;

@interface DFPhotoKitManager : NSObject

@property (assign, nonatomic) DFPhotoKitManagerSelectedType type;
/**
 获取相册权限
 @param stateBlock yes 同意
 */
- (void)requestAuthorization:(void(^)(BOOL isAuthorization))stateBlock;
/**
 相册列表
 */
@property (nonatomic, strong, readonly) NSMutableArray *albums;
/**
 获取系统所有相册
 
 @param albums 相册集合
 */
- (void)getAllPhotoAlbums:(void(^)(NSArray<DFPhotoAlbumModel *> *albums))albums;
/**
 根据某个相册模型获取照片列表
 
 @param albumModel 相册模型
 */
- (void)getPhotoListWithAlbumModel:(DFPhotoAlbumModel *)albumModel complete:(void (^)(NSArray<DFPhotoModel *> *allList, NSArray<DFPhotoModel *> *photoList, NSArray<DFPhotoModel *> *videoList))complete;
@end
