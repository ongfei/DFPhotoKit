//
//  DFPhotoKitManager.m
//  iOS8
//
//  Created by ongfei on 2018/5/4.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPhotoKitManager.h"
#import "DFPhotoModel.h"

@interface DFPhotoKitManager ()

@property (nonatomic, strong) NSMutableArray *albums;

@end
@implementation DFPhotoKitManager

- (PHAuthorizationStatus)authorizationStatus {
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthStatus) {
        case PHAuthorizationStatusNotDetermined:
            NSLog(@"未询问用户是否授权");
            break;
        case PHAuthorizationStatusRestricted:
            NSLog(@"未授权，例如家长控制");
            break;
        case PHAuthorizationStatusDenied:
            NSLog(@"未授权，用户拒绝造成的");
            break;
        case PHAuthorizationStatusAuthorized:
            break;
        default:
            break;
    }
    return photoAuthStatus;
}

- (void)requestAuthorization:(void(^)(BOOL isAuthorization))stateBlock {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            stateBlock(YES);
        }else {
            stateBlock(NO);
        }
    }];
}

/**
 获取系统所有相册
 
 @param albums 相册集合
 */
- (void)getAllPhotoAlbums:(void(^)(NSArray *albums))albums {

    if (self.albums.count > 0) [self.albums removeAllObjects];
    // 获取系统智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册 最近添加 最近删除
        if (result.count > 0 && ![collection.localizedTitle isEqualToString:@"Recently Deleted"] && ![collection.localizedTitle isEqualToString:@"Recently Added"]) {
            DFPhotoAlbumModel *albumModel = [[DFPhotoAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = collection.localizedTitle;
            albumModel.albumNameCh = [DFPhotoKitDeal transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"All Photos"]) {
                [self.albums insertObject:albumModel atIndex:0];
            }else {
                [self.albums addObject:albumModel];
            }
        }

    }];

    // 获取用户相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        // 是否按创建时间排序
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

        // 获取照片集合
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        
        // 过滤掉空相册
        if (result.count > 0) {
            DFPhotoAlbumModel *albumModel = [[DFPhotoAlbumModel alloc] init];
            albumModel.count = result.count;
            albumModel.albumName = collection.localizedTitle;
            albumModel.albumNameCh = [DFPhotoKitDeal transFormPhotoTitle:collection.localizedTitle];
            albumModel.result = result;
            [self.albums addObject:albumModel];
        }
    }];
   
    if (albums) {
        albums(self.albums);
    }
}

/**
 根据某个相册模型获取照片列表
 
 @param albumModel 相册模型
 */
- (void)getPhotoListWithAlbumModel:(DFPhotoAlbumModel *)albumModel complete:(void (^)(NSArray *allList, NSArray *photoList, NSArray *videoList))complete {
    
    NSMutableArray *allArray = [NSMutableArray array];
    NSMutableArray *videoArray = [NSMutableArray array];
    NSMutableArray *photoArray = [NSMutableArray array];
    
    [albumModel.result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        DFPhotoModel *photoModel = [[DFPhotoModel alloc] init];
        photoModel.asset = asset;
        
        if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
            NSLog(@"------isCloudPlaceholder");
        }
        
        if (asset.mediaType == PHAssetMediaTypeImage) {
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                photoModel.type = DFPhotoModelMediaTypePhotoGif;
            }else if (@available(iOS 9.1, *)) {
                if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive){
                    photoModel.type = DFPhotoModelMediaTypeLivePhoto;
                }else {
                    photoModel.type = DFPhotoModelMediaTypePhoto;
                }
            }
            [photoArray addObject:photoModel];
            
        }else if (asset.mediaType == PHAssetMediaTypeVideo) {
            photoModel.type = DFPhotoModelMediaTypeVideo;
            [videoArray addObject:photoModel];
            
        }

        [allArray addObject:photoModel];

    }];
    
    if (complete) {
        complete(allArray,photoArray,videoArray);
    }
}


#pragma mark -  ----------lazy loading----------

- (NSMutableArray *)albums {
    if (!_albums) {
        _albums = [NSMutableArray array];
    }
    return _albums;
}

@end
