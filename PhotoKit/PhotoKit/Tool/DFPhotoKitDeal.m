//
//  DFPhotoKitDeal.m
//  iOS8
//
//  Created by ongfei on 2018/5/4.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPhotoKitDeal.h"


@implementation DFPhotoKitDeal

+ (PHImageRequestID)getImageData:(PHAsset *)asset completion:(void(^)(NSData *imageData, UIImageOrientation orientation))completion error:(void(^)(void))error {
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
//    option.networkAccessAllowed = NO;
//    option.synchronous = NO;
    
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && imageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(imageData, orientation);
                }
            });
        }
    }];
}
/**
 通过相册model获取image
 */
+ (PHImageRequestID)getImageWithAlbumModel:(DFPhotoAlbumModel *)model size:(CGSize)size completion:(void (^)(UIImage *image, DFPhotoAlbumModel *model))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    return [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(result,model);
            });
        }
    }];
}

/**
 根据PHAsset获取图片信息
 执行一次
 */
+ (PHImageRequestID)getHighQualityFormatPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion error:(void(^)(NSDictionary *info))error {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
     //如果deliveryMode是HighQualityFormat ，resultHandler调用一次，框架只返回高质量图。
     //如果deliveryMode是FastFormat，resultHandler也只被调用一次，保证速度尽可能保证图片质量。
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
//    option.networkAccessAllowed = NO;
    
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(result,info);
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    error(info);
                }
            });
        }
    }];
    return requestID;
}
/**
 根据PHAsset获取图片信息
 执行多次
 */
+ (PHImageRequestID)getPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
//    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        
        if (downloadFinined && completion && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result,info);
            });
        }else {
//            PHImageRequestOptions networkAccessAllowed 要设置yes;
            //需要的话 调用下面从icloud获取
        }
    }];
}
/**
 根据PHAsset获取LivePhoto
 */
+ (PHImageRequestID)getLivePhotoForAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(PHLivePhoto *livePhoto))completion failed:(void(^)(void))failed  API_AVAILABLE(ios(9.1)) {
    
    PHLivePhotoRequestOptions *option = [[PHLivePhotoRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    return [[PHImageManager defaultManager] requestLivePhotoForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && completion && livePhoto) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(livePhoto);
            });
        }else {
            if(failed) {
                failed();
            }
            //需要的话 调用下面从icloud获取
        }
    }];
}

+ (PHImageRequestID)getPlayerItemWithPHAsset:(PHAsset *)asset completion:(void(^)(AVPlayerItem *playerItem))completion failed:(void(^)(void))failed {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    return [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && playerItem) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(playerItem);
                }
            });
        }else {
            if(failed) {
                failed();
            }
            //需要的话 调用下面从icloud获取
        }
    }];
}

+ (PHImageRequestID)getAVAssetWithPHAsset:(PHAsset *)phAsset completion:(void(^)(AVAsset *asset))completion failed:(void(^)(void))failed {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    return [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(asset);
                }
            });
        }else {
            if(failed) {
                failed();
            }
            //需要的话 调用下面从icloud获取
        }
    }];
}

#pragma mark -  ----------从icloud获取----------
/**
 获取icloud的AVAsset
 */
- (void)requestAVAssetFromeIcloudWithDic:(NSDictionary *)info asset:(PHAsset *)asset size:(CGSize)size progress:(void(^)(double progress))progressHandler completion:(void(^)(AVAsset *asset))completion error:(void(^)(void))error  API_AVAILABLE(ios(9.1)) {
    if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
        PHImageRequestID cloudRequestId = 0;
        PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
        cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
        cloudOptions.networkAccessAllowed = YES;
        cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressHandler) {
                    progressHandler(progress);
                }
            });
        };
        cloudRequestId = [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:cloudOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            if (downloadFinined && asset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(asset);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        error();
                    }
                });
            }
        }];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                error();
            }
        });
    }
}
/**
 获取icloud的AVPlayerItem
 */
- (void)requestPlayerItemFromeIcloudWithDic:(NSDictionary *)info asset:(PHAsset *)asset size:(CGSize)size progress:(void(^)(double progress))progressHandler completion:(void(^)(AVPlayerItem *playerItem))completion error:(void(^)(void))error  API_AVAILABLE(ios(9.1)) {
    
    if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
        PHImageRequestID cloudRequestId = 0;
        PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
        cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
        cloudOptions.networkAccessAllowed = YES;
        cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressHandler) {
                    progressHandler(progress);
                }
            });
        };
        cloudRequestId = [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:cloudOptions resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            if (downloadFinined && playerItem) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(playerItem);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        error();
                    }
                });
            }
        }];
        
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                error();
            }
        });
    }
}
/**
 获取icloud的livephoto
 */
- (void)requestLivePhotoFromeIcloudWithDic:(NSDictionary *)info asset:(PHAsset *)asset size:(CGSize)size progress:(void(^)(double progress))progressHandler completion:(void(^)(PHLivePhoto *livePhoto))completion error:(void(^)(void))error API_AVAILABLE(ios(9.1)) {
    if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]) {
        PHImageRequestID iCloudRequestId = 0;
        PHLivePhotoRequestOptions *iCloudOption = [[PHLivePhotoRequestOptions alloc] init];
        iCloudOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        iCloudOption.networkAccessAllowed = YES;
        iCloudOption.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressHandler) {
                    progressHandler(progress);
                }
            });
        };
        iCloudRequestId = [[PHImageManager defaultManager] requestLivePhotoForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:iCloudOption resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            if (downloadFinined && livePhoto) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(livePhoto);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        error();
                    }
                });
            }
        }];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                error();
            }
        });
    }
}

/**
 如本地没有图 需要去icloud下载
 photo
 @param info PHImageManager block 里的 info
 @param asset phasset
 @param size 需要的图片大小
 @param progressHandler 下载的进度
 @param completion 完成回调
 @param error 错误
 */
- (void)requestImageFromeIcloudWithDic:(NSDictionary *)info asset:(PHAsset *)asset size:(CGSize)size progress:(void(^)(double progress))progressHandler completion:(void(^)(UIImage *image,NSDictionary *info))completion error:(void(^)(NSDictionary *info))error {
    if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]) {
        PHImageRequestID cloudRequestId = 0;
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        option.networkAccessAllowed = YES;
        option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressHandler) {
                    progressHandler(progress);
                }
            });
        };
        cloudRequestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            if (downloadFinined && result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(result,info);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        error(info);
                    }
                });
            }
        }];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                error(info);
            }
        });
    }
}

+ (void)savePhotoToCustomAlbumWithName:(NSString *)albumName photo:(UIImage *)photo state:(void(^)(BOOL state))saveState {
    if (!photo) {
        return;
    }
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (([UIDevice currentDevice].systemVersion.floatValue < 9.0f)) {
                UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
                return;
            }
            NSError *error = nil;
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:photo].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                saveState(NO);
                return;
            }else {
                saveState(YES);
            }
            
            if (albumName != nil && ![albumName isEqualToString:@""]) {
                
                // 拿到自定义的相册对象
                PHAssetCollection *collection = [self createCollection:albumName];
                if (collection == nil) {
//                    NSLog(@"保存自定义相册失败");
                    return;
                }
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
                } error:&error];
                
//                if (error) {
//                    NSLog(@"保存自定义相册失败");
//                } else {
//                    NSLog(@"保存成功");
//                }
            }
        });
    }];
}

// 创建自己要创建的自定义相册
+ (PHAssetCollection * )createCollection:(NSString *)albumName {
    NSString * title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    PHFetchResult<PHAssetCollection *> *collections =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHAssetCollection * createCollection = nil;
    for (PHAssetCollection * collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            createCollection = collection;
            break;
        }
    }
    if (createCollection == nil) {
        
        NSError * error1 = nil;
        __block NSString * createCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            NSString * title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
            createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error1];
        
        if (error1) {
//            NSLog(@"创建相册失败...");
            return nil;
        }
        // 创建相册之后我们还要获取此相册  因为我们要往进存储相片
        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
    }
    
    return createCollection;
}

#pragma mark -  ----------相册名称转中文----------
/**
 相册名称转换
 */
+ (NSString *)transFormPhotoTitle:(NSString *)englishName {
    NSString *photoName;
    if ([englishName isEqualToString:@"Bursts"]) {
        photoName = @"连拍快照";
    }else if([englishName isEqualToString:@"Recently Added"]){
        photoName = @"最近添加";
    }else if([englishName isEqualToString:@"Screenshots"]){
        photoName = @"屏幕快照";
    }else if([englishName isEqualToString:@"Camera Roll"]){
        photoName = @"相机胶卷";
    }else if([englishName isEqualToString:@"Selfies"]){
        photoName = @"自拍";
    }else if([englishName isEqualToString:@"My Photo Stream"]){
        photoName = @"我的照片流";
    }else if([englishName isEqualToString:@"Videos"]){
        photoName = @"视频";
    }else if([englishName isEqualToString:@"All Photos"]){
        photoName = @"所有照片";
    }else if([englishName isEqualToString:@"Slo-mo"]){
        photoName = @"慢动作";
    }else if([englishName isEqualToString:@"Recently Deleted"]){
        photoName = @"最近删除";
    }else if([englishName isEqualToString:@"Favorites"]){
        photoName = @"个人收藏";
    }else if([englishName isEqualToString:@"Panoramas"]){
        photoName = @"全景照片";
    }else {
        photoName = englishName;
    }
    return photoName;
}

#pragma mark -  ----------获取对应的image----------
/**
 通过DFPhotoModel获取对应的image数组
 @param scale 缩放比率
 */
+ (void)getSelectedImageList:(NSArray<DFPhotoModel *> *)modelList type:(DFPhotoSizeType)type scale:(CGFloat)scale success:(void(^)(NSArray<UIImage *> *imageArr))success failed:(void(^)(void))failed {
    if (modelList.count == 0) {
        return;
    }
    NSMutableArray<UIImage *> *imageArr = [NSMutableArray array];
    for (DFPhotoModel *model in modelList) {
        if (model.asset) {
            CGSize size;
            if (type == DFPhotoSizeTypeOriginal) {
                size = model.imageSize;
            }else if (type == DFPhotoSizeTypeScaleScreen) {
                size = model.previewImageSize;
            }else {
                size = model.previewFillImageSize;
            }
            [self getHighQualityFormatPhotoForPHAsset:model.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                [imageArr addObject:[self normalizedImageWithImg:image scale:scale]];
                if (imageArr.count == modelList.count) {
                    success(imageArr);
                }
            } error:^(NSDictionary *info) {
                failed();
            }];
        }
    }
    
}
/**
 通过DFPhotoModel存入本地临时文件
 */
+ (void)writeSelectModelListToTempPathWithList:(NSArray<DFPhotoModel *> *)modelList type:(DFPhotoSizeType)type scale:(CGFloat)scale success:(void(^)(NSArray<NSURL *> *allURL,NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL))success failed:(void(^)(void))failed {
    if (modelList.count == 0) {
        return;
    }
    __block __weak typeof(self) weakSelf = self;

    NSMutableArray *allUrl = [NSMutableArray arrayWithCapacity:modelList.count];
    NSMutableArray *photoUrl = [NSMutableArray array];
    NSMutableArray *videoUrl = [NSMutableArray array];

    for (DFPhotoModel *model in modelList) {
        if (model.type == DFPhotoModelMediaTypeVideo) {
//            视频处理
            __block __weak typeof(self) weakSelf = self;
            [self getAVAssetWithPHAsset:model.asset completion:^(AVAsset *asset) {
                
                [weakSelf compressedVideoWithMediumQualityWriteToTemp:asset fileName:[model.asset.localIdentifier componentsSeparatedByString:@"/"].firstObject success:^(NSURL *url) {
                    
                    [allUrl addObject:url];
                    [videoUrl addObject:url];
                    if (allUrl.count == modelList.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(allUrl,photoUrl,videoUrl);
                        });
                    }
                    
                } failure:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failed();
                    });
                }];
                
            } failed:^{
                failed();
            }];
            
        }else if (model.type == DFPhotoModelMediaTypePhotoGif) {
            
            [self getImageData:model.asset completion:^(NSData *imageData, UIImageOrientation orientation) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSString *fileName = [[model.asset.localIdentifier componentsSeparatedByString:@"/"].firstObject stringByAppendingString:[NSString stringWithFormat:@".gif"]];
                    
                    NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
                    
                    if ([imageData writeToFile:fullPathToFile atomically:YES]) {
                        [allUrl addObject:[NSURL fileURLWithPath:fullPathToFile]];
                        [photoUrl addObject:[NSURL fileURLWithPath:fullPathToFile]];
                        if (allUrl.count == modelList.count) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                success(allUrl,photoUrl,videoUrl);
                            });
                        }
                        
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failed();
                        });
                    }
                });
            } error:^{
                failed();
            }];
            
        }else {
            
            CGSize size;
            if (type == DFPhotoSizeTypeOriginal) {
                size = model.imageSize;
            }else if (type == DFPhotoSizeTypeScaleScreen) {
                size = model.previewImageSize;
            }else {
                size = model.previewFillImageSize;
            }

            [self getHighQualityFormatPhotoForPHAsset:model.asset size:size completion:^(UIImage *image, NSDictionary *info) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *tempImage = image;
                    if (tempImage.imageOrientation != UIImageOrientationUp) {
                        tempImage = [weakSelf normalizedImageWithImg:tempImage scale:scale];
                    }
                    NSData *imageData;
                    NSString *suffix;
                    if (UIImagePNGRepresentation(tempImage)) {
                        //返回为png图像。
                        imageData = UIImagePNGRepresentation(tempImage);
                        suffix = @"png";
                    }else {
                        //返回为JPEG图像。
                        imageData = UIImageJPEGRepresentation(tempImage, 0.8);
                        suffix = @"jpeg";
                    }

                    NSString *fileName = [[model.asset.localIdentifier componentsSeparatedByString:@"/"].firstObject stringByAppendingString:[NSString stringWithFormat:@".%@",suffix]];
                    
                    NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
                    
                    if ([imageData writeToFile:fullPathToFile atomically:YES]) {
                        [allUrl addObject:[NSURL fileURLWithPath:fullPathToFile]];
                        [photoUrl addObject:[NSURL fileURLWithPath:fullPathToFile]];
                        if (allUrl.count == modelList.count) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                success(allUrl,photoUrl,videoUrl);
                            });
                        }
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failed();
                        });
                    }
                });
            } error:^(NSDictionary *info) {
                failed();
            }];
        }
    }
}

+ (AVAssetExportSession *)compressedVideoWithMediumQualityWriteToTemp:(id)obj fileName:(NSString *)filename success:(void (^)(NSURL *url))success failure:(void (^)(void))failure {
    AVAsset *avAsset;
    if ([obj isKindOfClass:[AVAsset class]]) {
        avAsset = obj;
    }else {
        avAsset = [AVURLAsset URLAssetWithURL:obj options:nil];
    }
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        NSString *fileName = [filename stringByAppendingString:@".mp4"];
        NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSURL *videoURL = [NSURL fileURLWithPath:fullPathToFile];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:fullPathToFile]) {
            success(videoURL);
            return nil;
        }else {
            exportSession.outputURL = videoURL;
            exportSession.outputFileType = AVFileTypeMPEG4;
            exportSession.shouldOptimizeForNetworkUse = YES;
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                    if (success) {
                        success(videoURL);
                    }
                }else if ([exportSession status] == AVAssetExportSessionStatusFailed){
                    if (failure) {
                        failure();
                    }
                }else if ([exportSession status] == AVAssetExportSessionStatusCancelled) {
                    if (failure) {
                        failure();
                    }
                }
            }];
            return exportSession;
        }
        
    }else {
        if (failure) {
            failure();
        }
        return nil;
    }
}

+ (BOOL)clearTempImageCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subPaths = [fileManager contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
    BOOL result = YES;
    for (NSString *subPath in subPaths) {
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:subPath];
        BOOL isSucc = [fileManager removeItemAtPath:filePath error:nil];
        if (!isSucc) {
            result = NO;
            return result;
        }
    }
    return result;
}

+ (UIImage *)normalizedImageWithImg:(UIImage *)img scale:(CGFloat)scale {
    
    if (img.imageOrientation == UIImageOrientationUp) return img;
    
    UIGraphicsBeginImageContextWithOptions(img.size, NO, scale);
    [img drawInRect:(CGRect){0, 0, img.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

#pragma mark -  ----------gif图 转自yykit----------

static NSTimeInterval _yy_CGImageSourceGetGIFFrameDelayAtIndex(CGImageSourceRef source, size_t index) {
    NSTimeInterval delay = 0;
    CFDictionaryRef dic = CGImageSourceCopyPropertiesAtIndex(source, index, NULL);
    if (dic) {
        CFDictionaryRef dicGIF = CFDictionaryGetValue(dic, kCGImagePropertyGIFDictionary);
        if (dicGIF) {
            NSNumber *num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFUnclampedDelayTime);
            if (num.doubleValue <= __FLT_EPSILON__) {
                num = CFDictionaryGetValue(dicGIF, kCGImagePropertyGIFDelayTime);
            }
            delay = num.doubleValue;
        }
        CFRelease(dic);
    }
    
    // http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility
    if (delay < 0.02) delay = 0.1;
    return delay;
}

+ (UIImage *)animatedGIFWithData:(NSData *)data {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)(data), NULL);
    if (!source) return nil;
    
    size_t count = CGImageSourceGetCount(source);
    if (count <= 1) {
        CFRelease(source);
        return [UIImage imageWithData:data scale:1.0];
    }
    
    NSUInteger frames[count];
    double oneFrameTime = 1 / 50.0; // 50 fps
    NSTimeInterval totalTime = 0;
    NSUInteger totalFrame = 0;
    NSUInteger gcdFrame = 0;
    for (size_t i = 0; i < count; i++) {
        NSTimeInterval delay = _yy_CGImageSourceGetGIFFrameDelayAtIndex(source, i);
        totalTime += delay;
        NSInteger frame = lrint(delay / oneFrameTime);
        if (frame < 1) frame = 1;
        frames[i] = frame;
        totalFrame += frames[i];
        if (i == 0) gcdFrame = frames[i];
        else {
            NSUInteger frame = frames[i], tmp;
            if (frame < gcdFrame) {
                tmp = frame; frame = gcdFrame; gcdFrame = tmp;
            }
            while (true) {
                tmp = frame % gcdFrame;
                if (tmp == 0) break;
                frame = gcdFrame;
                gcdFrame = tmp;
            }
        }
    }
    NSMutableArray *array = [NSMutableArray new];
    for (size_t i = 0; i < count; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!imageRef) {
            CFRelease(source);
            return nil;
        }
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        if (width == 0 || height == 0) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, space, bitmapInfo);
        CGColorSpaceRelease(space);
        if (!context) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef decoded = CGBitmapContextCreateImage(context);
        CFRelease(context);
        if (!decoded) {
            CFRelease(source);
            CFRelease(imageRef);
            return nil;
        }
        UIImage *image = [UIImage imageWithCGImage:decoded scale:1.0 orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        CGImageRelease(decoded);
        if (!image) {
            CFRelease(source);
            return nil;
        }
        for (size_t j = 0, max = frames[i] / gcdFrame; j < max; j++) {
            [array addObject:image];
        }
    }
    CFRelease(source);
    UIImage *image = [UIImage animatedImageWithImages:array duration:totalTime];
    return image;
}

+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    //获取这一帧图片的属性字典
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    //获取gif属性字典
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    //获取这一帧持续的时间
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    //如果帧数小于0.1,则指定为0.1
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}


//            拆分livephoto
//            NSArray *assetResources = [PHAssetResource assetResourcesForAsset:photoM.asset];
//
//            PHAssetResource *resource;
//
//            for (PHAssetResource *assetRes in assetResources) {
//
//                if (assetRes.type == PHAssetResourceTypePairedVideo ||
//
//                    assetRes.type == PHAssetResourceTypeVideo) {
//
//                    resource = assetRes;
//
//                }
//            }
//            合并livephoto
//            NSURL *photoURL = [NSURL fileURLWithPath:photoURLstring];//
//            NSURL *videoURL = [NSURL fileURLWithPath:videoURLstring];//
//            [[PHPhotoLibrary sharedPhotoLibrary] performChanges: ^{
//                PHAssetCreationRequest * request = [PHAssetCreationRequest creationRequestForAsset];
//                [request addResourceWithType: PHAssetResourceTypePhoto fileURL: photoURL options: nil];
//                [request addResourceWithType: PHAssetResourceTypePairedVideo fileURL: videoURL options: nil];
//            } completionHandler: ^(BOOL success, NSError * _Nullable error) {
//                if (success) { [self alertMessage: @"LivePhotos 已经保存至相册!"];
//                } else {
//                    NSLog(@"error: %@", error);
//                }
//            }];

@end
