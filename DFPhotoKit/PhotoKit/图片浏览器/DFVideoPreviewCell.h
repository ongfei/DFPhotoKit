//
//  DFVideoPreviewCell.h
//  iOS8
//
//  Created by ongfei on 2018/6/14.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPhotoModel.h"
#import "DFPhotoKitDeal.h"
#import "DFImageView.h"

@interface DFVideoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) DFPhotoModel *videoM;
@property (nonatomic, strong) DFImageView *imageV;
@property (nonatomic, copy) void(^singleTap)(void);

- (void)displayImg;
@end
