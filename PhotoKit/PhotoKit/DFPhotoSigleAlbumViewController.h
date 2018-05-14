//
//  DFPhotoSigleAlbumViewController.h
//  iOS8
//
//  Created by ongfei on 2018/5/7.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPhotoKitManager.h"

@interface DFPhotoSigleAlbumViewController : UIViewController

@property (nonatomic, strong) DFPhotoAlbumModel *album;

@end

@interface DFPhotoSigleCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *intrL;

@property (nonatomic, strong) DFPhotoModel *photoM;

@end
