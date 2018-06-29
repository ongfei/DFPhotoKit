//
//  DFPhotoKitCollectionViewController.h
//  iOS8
//
//  Created by ongfei on 2018/5/4.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPhotoKitManager.h"
#import "DFPhotoKitDeal.h"

@interface DFPhotoKitCollectionViewController : UIViewController


@end

@interface PhotoKitCollectionCell : UICollectionViewCell

@property (nonatomic, strong) DFPhotoAlbumModel *albumModel;

@end
