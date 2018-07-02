//
//  DFPhotoSigleAlbumViewController.m
//  iOS8
//
//  Created by ongfei on 2018/5/7.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPhotoSigleAlbumViewController.h"
#import "DFPhotoModel.h"
#import <Masonry.h>
#import "DFPhotoSigleAlbumCell.h"
#import "DFPhotoSigleAlbumCameraCell.h"

#import "DFPreviewViewController.h"

@interface DFPhotoSigleAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DFPreviewViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *previewBtn;
@property (nonatomic, strong) UIButton *originalBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UILabel *countL;

@property (nonatomic, assign) NSInteger maxPhotoCount;
@property (nonatomic, assign) NSInteger maxVideoCount;

@property (nonatomic, strong) DFPhotoKitManager *photoManager;

@property (nonatomic, strong) NSArray *sourceArr;
@property (nonatomic, strong) NSArray *photoList;
@property (nonatomic, strong) NSArray *videoList;
@property (nonatomic, strong) NSMutableArray *selectPhotoArr;
@property (nonatomic, strong) NSMutableArray *selectVideoArr;

@end

@implementation DFPhotoSigleAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectPhotoArr = [NSMutableArray array];
    self.selectVideoArr = [NSMutableArray array];
    self.maxPhotoCount = 9;
    self.maxVideoCount = 3;
    
    [self customViewLayout];
    
    self.photoManager = [DFPhotoKitManager new];
    
    [self.photoManager getPhotoListWithAlbumModel:self.album complete:^(NSArray<DFPhotoModel *> *allList, NSArray<DFPhotoModel *> *photoList, NSArray<DFPhotoModel *> *videoList) {
        
        self.sourceArr = [NSArray arrayWithArray:allList];
        self.photoList = [NSArray arrayWithArray:photoList];
        self.videoList = [NSArray arrayWithArray:videoList];
        [self.collectionView reloadData];
    }];
}

- (void)customViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 25) / 4, ([UIScreen mainScreen].bounds.size.width - 25) / 4);
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.89 alpha:1];
    
    [self.collectionView registerClass:[DFPhotoSigleAlbumCell class] forCellWithReuseIdentifier:@"DFPhotoSigleAlbumCell"];
    [self.collectionView registerClass:[DFPhotoSigleAlbumCameraCell class] forCellWithReuseIdentifier:@"DFPhotoSigleAlbumCameraCell"];
    
    UIView *toolBarView = [[UIView alloc] init];
    [self.view addSubview:toolBarView];
    
    [toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0,*)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(toolBarView.mas_top);
    }];
    
    self.previewBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [toolBarView addSubview:self.previewBtn];
    [self.previewBtn setTitle:@"预览" forState:(UIControlStateNormal)];
    [self.previewBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    [self.previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolBarView);
        make.left.equalTo(toolBarView).offset(10);
    }];
    
    self.originalBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [toolBarView addSubview:self.originalBtn];
    [self.originalBtn setImage:[UIImage imageNamed:@"common_select"] forState:(UIControlStateSelected)];
    [self.originalBtn setImage:[UIImage imageNamed:@"common_unselect"] forState:(UIControlStateNormal)];
    [self.originalBtn setTitle:@"原图" forState:(UIControlStateNormal)];
    [self.originalBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    self.originalBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [self.originalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolBarView);
        make.left.equalTo(self.previewBtn.mas_right).offset(10);
        make.width.mas_equalTo(80);
    }];
    [self.originalBtn addTarget:self action:@selector(originalBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.nextBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [toolBarView addSubview:self.nextBtn];
    [self.nextBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    self.nextBtn.layer.cornerRadius = 15;
    self.nextBtn.clipsToBounds = YES;
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.nextBtn setBackgroundColor:[UIColor grayColor]];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolBarView);
        make.right.equalTo(toolBarView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.countL = [[UILabel alloc] init];
    [toolBarView addSubview:self.countL];
    self.countL.layer.cornerRadius = 10;
    self.countL.font = [UIFont systemFontOfSize:11];
    self.countL.backgroundColor = [UIColor blueColor];
    self.countL.textColor = [UIColor whiteColor];
    self.countL.textAlignment = NSTextAlignmentCenter;
    self.countL.hidden = YES;
    self.countL.clipsToBounds = YES;
    [self.countL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.nextBtn.mas_left).offset(-10);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(toolBarView);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.sourceArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block __weak typeof(self) weakSelf = self;
    if (indexPath.item == 0) {
        DFPhotoSigleAlbumCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DFPhotoSigleAlbumCameraCell" forIndexPath:indexPath];
        [cell.session startRunning];
        cell.cameraBtnClick = ^{
            NSLog(@"点击了跳转相机");
            [weakSelf alertWithStr:@"点击了相机"];
        };
        return cell;
    }else {
        DFPhotoSigleAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DFPhotoSigleAlbumCell" forIndexPath:indexPath];
        DFPhotoModel *model = self.sourceArr[indexPath.item - 1];
        cell.photoM = model;
        if (self.selectPhotoArr.count > 0) {
            if ([self.selectPhotoArr containsObject:model]) {
                cell.isSelect = YES;
            }else {
                cell.isSelect = NO;
            }
        }
        if (self.selectVideoArr.count > 0) {
            if ([self.selectVideoArr containsObject:model]) {
                cell.isSelect = YES;
            }else {
                cell.isSelect = NO;
            }
        }
        cell.selectBlock = ^BOOL(BOOL selectState, DFPhotoModel *photoM) {
            return [weakSelf selectBtnClick:selectState photoModel:photoM];
        };
        
        return cell;
    }
    
}

- (BOOL)selectBtnClick:(BOOL)state photoModel:(DFPhotoModel *)model {
    if (model.type != DFPhotoModelMediaTypeVideo) {
        if (self.selectVideoArr.count > 0) {
            [self alertWithStr:@"照片视频不能同时选择"];
            return NO;
        }else {
            if (state && self.selectPhotoArr.count + 1 > self.maxPhotoCount) {
                [self alertWithStr:[NSString stringWithFormat:@"最多选择%ld张照片",self.maxPhotoCount]];
                return NO;
            }
            if (state && ![self.selectPhotoArr containsObject:model]) {
                [self.selectPhotoArr addObject:model];
            }
            if (!state && [self.selectPhotoArr containsObject:model]) {
                [self.selectPhotoArr removeObject:model];
            }
            [self changeCount];
            return YES;
        }
    }else {
        if (self.selectPhotoArr.count > 0) {
            [self alertWithStr:@"照片视频不能同时选择"];
            return NO;
        }else {
            if (state && self.selectVideoArr.count + 1 > self.maxVideoCount) {
                [self alertWithStr:[NSString stringWithFormat:@"最多选择%ld个视频",self.maxVideoCount]];
                return NO;
            }
            if (state && ![self.selectVideoArr containsObject:model]) {
                [self.selectVideoArr addObject:model];
            }
            if (!state && [self.selectVideoArr containsObject:model]) {
                [self.selectVideoArr removeObject:model];
            }
            [self changeCount];
            return YES;
        }
    }
    
}

- (void)alertWithStr:(NSString *)str {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        NSLog(@"点击了跳转相机");
        [self alertWithStr:@"点击了相机"];
    }else {
        DFPhotoModel *photoM = self.sourceArr[indexPath.item - 1];
        
        DFPreviewViewController *preview = [DFPreviewViewController new];
        preview.photoM = self.sourceArr[indexPath.item - 1];
        preview.selectedType = self.selectPhotoArr.count > 0 ? DFPreviewViewTypePhoto : self.selectVideoArr.count > 0 ? DFPreviewViewTypeVideo : DFPreviewViewTypeNone;
        
        if (photoM.type == DFPhotoModelMediaTypeVideo) {
            
            preview.sourceArr = self.videoList;
            preview.type = DFPreviewViewTypeVideo;
            preview.selectArr = [NSMutableArray arrayWithArray:self.selectVideoArr];
            preview.maxPhotoCount = self.maxVideoCount;
            preview.delegate = self;
            
            [self presentViewController:preview animated:YES completion:nil];
            
        }else {
            
            preview.sourceArr = self.photoList;
            preview.type = DFPreviewViewTypePhoto;
            preview.selectArr = [NSMutableArray arrayWithArray:self.selectPhotoArr];
            preview.maxPhotoCount = self.maxPhotoCount;
            preview.delegate = self;
            
            [self presentViewController:preview animated:YES completion:nil];
        }
    }
}

- (void)originalBtnClick {
    self.originalBtn.selected = !self.originalBtn.selected;
    
}

-(void)changeCount {
    self.countL.hidden = NO;
    if (self.selectPhotoArr.count > 0) {
        self.countL.text = [NSString stringWithFormat:@"%ld",self.selectPhotoArr.count];
        self.originalBtn.hidden = NO;
    }else if (self.selectVideoArr.count > 0) {
        self.countL.text = [NSString stringWithFormat:@"%ld",self.selectVideoArr.count];
        self.originalBtn.hidden = YES;
    }else {
        self.countL.text = @"0";
        self.countL.hidden = YES;
        self.originalBtn.hidden = NO;
    }
    
    if (self.selectPhotoArr.count != 0 || self.selectVideoArr.count != 0) {
        [self.nextBtn setBackgroundColor:[UIColor orangeColor]];
    }else {
        [self.nextBtn setBackgroundColor:[UIColor grayColor]];
    }
}

- (void)nextBtnClick {
    NSLog(@"%@", [NSString stringWithFormat:@"selectPhotoCount = %ld--  selectVideoCount = %ld",self.selectPhotoArr.count,self.selectVideoArr.count]);
    
    
    NSLog(@"\r ----------------------点击开始");
    
    if (self.selectPhotoArr.count == 0 && self.selectVideoArr.count == 0) {
        return;
    }

    NSArray *arr = self.selectPhotoArr.count > 0 ? self.selectPhotoArr : self.selectVideoArr.count > 0 ? self.selectVideoArr : nil;
    CGFloat scale = 0.8;
    if (self.originalBtn.selected && !self.originalBtn.hidden) {
        scale = 1;
    }
    
    [DFPhotoKitDeal writeSelectModelListToTempPathWithList:arr  type:DFPhotoSizeTypeScaleScreen scale:scale success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
        
        NSLog(@"%@",allURL);
        NSLog(@"%@",[NSTemporaryDirectory() stringByAppendingPathComponent:@""]);
        NSLog(@"\r ----------------------保存成功");
        
    } failed:^{
        
    }];
}

#pragma mark -  ----------delegate----------

- (void)changeSelectPhoto:(NSMutableArray *)selectArr andSelectedType:(DFPreviewViewType)selectedType andType:(DFPreviewViewType)type {

    
    if (type == DFPreviewViewTypePhoto && selectedType != DFPreviewViewTypeVideo) {
        [self.selectPhotoArr removeAllObjects];
        [self.selectPhotoArr addObjectsFromArray:selectArr];
        [self.collectionView reloadData];
        [self changeCount];
    }
    
    if (type == DFPreviewViewTypeVideo && selectedType != DFPreviewViewTypePhoto) {
        [self.selectVideoArr removeAllObjects];
        [self.selectVideoArr addObjectsFromArray:selectArr];
        [self.collectionView reloadData];
        [self changeCount];
    }
    
}



@end

