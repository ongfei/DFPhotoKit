//
//  DFPhotoPreviewViewController.h
//  iOS8
//
//  Created by ongfei on 2018/5/9.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFPhotoModel.h"
#import <PhotosUI/PhotosUI.h>

@interface DFPhotoPreviewViewController : UIViewController

@property (nonatomic, strong) DFPhotoModel *photoM;

@property (nonatomic, strong) NSArray *sourceArr;

@end
