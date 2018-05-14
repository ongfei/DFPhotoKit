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

@interface DFPhotoKitManager : NSObject
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
- (void)getAllPhotoAlbums:(void(^)(NSArray *albums))albums;
/**
 根据某个相册模型获取照片列表
 
 @param albumModel 相册模型
 */
- (void)getPhotoListWithAlbumModel:(DFPhotoAlbumModel *)albumModel complete:(void (^)(NSArray *allList, NSArray *photoList, NSArray *videoList))complete;
@end
