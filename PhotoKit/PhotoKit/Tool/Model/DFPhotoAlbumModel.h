//
//  DFPhotoAlbumModel.h
//  iOS8
//
//  Created by ongfei on 2018/5/4.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/**
 *  每个相册的模型
 */
@interface DFPhotoAlbumModel : NSObject
/**
 相册名称
 */
@property (nonatomic, strong) NSString *albumName;
/**
 相册中文名称
 */
@property (nonatomic, strong) NSString *albumNameCh;
/**
 照片数量
 */
@property (nonatomic, assign) NSInteger count;
/**
 封面Asset
 */
@property (nonatomic, strong) PHAsset *asset;
/**
 照片集合对象
 */
@property (nonatomic, strong) PHFetchResult *result;
@end
