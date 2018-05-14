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

+ (UIImage *)animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    //通过CFData读取gif文件的数据
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    //获取gif文件的帧数
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {//大于一张图片时
        NSMutableArray *images = [NSMutableArray array];
        //设置gif播放的时间
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            //获取gif指定帧的像素位图
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            //获取每张图的播放时间
            duration += [self frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        if (!duration) {//如果播放时间为空
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
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


@end
