//
//  DFPhotoSigleAlbumCell.h
//  iOS8
//
//  Created by ongfei on 2018/6/1.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPhotoModel.h"

@interface DFPhotoSigleAlbumCell : UICollectionViewCell

@property (nonatomic, copy) BOOL(^selectBlock)(BOOL selectState, DFPhotoModel *photoM);

@property (nonatomic, strong) DFPhotoModel *photoM;

@property (nonatomic, assign) BOOL isSelect;

@end
