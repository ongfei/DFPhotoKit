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

typedef enum : NSUInteger {
    DFPreviewViewTypePhoto,
    DFPreviewViewTypeVideo,
    DFPreviewViewTypeNone
} DFPreviewViewType;

@protocol DFPreviewViewDelegate <NSObject>

- (void)changeSelectPhoto:(NSMutableArray *)selectArr andSelectedType:(DFPreviewViewType)selectedType andType:(DFPreviewViewType)type;

@end
@interface DFPreviewViewController : UIViewController

@property (nonatomic, weak) id<DFPreviewViewDelegate> delegate;

@property (nonatomic, strong) DFPhotoModel *photoM;

@property (nonatomic, strong) NSArray *sourceArr;

@property (nonatomic, strong) NSMutableArray *selectArr;

@property (nonatomic, assign) NSInteger maxPhotoCount;
//已经选择的类型
@property (nonatomic, assign) DFPreviewViewType selectedType;
//展示的类型
@property (nonatomic, assign) DFPreviewViewType type;

@end
