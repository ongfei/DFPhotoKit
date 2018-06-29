//
//  DFPhotoPreviewCell.h
//  iOS8
//
//  Created by ongfei on 2018/5/9.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "DFPhotoModel.h"
#import "DFPhotoKitDeal.h"
#import "DFImageView.h"

@interface DFPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) UIScrollView *scrollBg;
@property (nonatomic, strong) DFImageView *imageV;

@property (nonatomic, strong) PHLivePhotoView *livePhoto;

@property (nonatomic, strong) DFPhotoModel *photoM;

@property (nonatomic, copy) void(^singleTap)(void);

- (void)stopEven;
- (void)resetScale;
@end
