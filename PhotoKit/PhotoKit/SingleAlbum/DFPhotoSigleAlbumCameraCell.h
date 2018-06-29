//
//  DFPhotoSigleAlbumCameraCell.h
//  iOS8
//
//  Created by ongfei on 2018/6/4.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface DFPhotoSigleAlbumCameraCell : UICollectionViewCell
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, copy) void(^cameraBtnClick)(void);

@end
