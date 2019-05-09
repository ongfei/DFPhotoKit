//
//  DFPreviewViewController.m
//  iOS8
//
//  Created by ongfei on 2018/5/9.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPreviewViewController.h"
#import <Masonry.h>
#import "DFPhotoKitDeal.h"
#import "DFPhotoPreviewCell.h"
#import "DFVideoPreviewCell.h"
#import "DFVideoPlayer.h"

#define stateBarFrame [UIApplication sharedApplication].statusBarFrame
#define safeAreaInsets [UIApplication sharedApplication].keyWindow.safeAreaInsets

@interface DFPreviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UILabel *countL;
@property (nonatomic, strong) UILabel *numberL;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation DFPreviewViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.nextBtn.hidden;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self preferredStatusBarStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self customViewLayout];
    [self loadData];
}

- (void)loadData {
    
    NSInteger index = [self.sourceArr indexOfObject:self.photoM];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
    if ([self.selectArr containsObject:self.photoM]) {
        self.selectBtn.selected = YES;
    }else {
        self.selectBtn.selected = NO;
    }
}

- (void)customViewLayout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height));
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.89 alpha:1];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[DFPhotoPreviewCell class] forCellWithReuseIdentifier:@"PhotoPreviewCell"];
    [self.collectionView registerClass:[DFVideoPreviewCell class] forCellWithReuseIdentifier:@"DFVideoPreviewCell"];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];

    
    UIView *barView = [UIView new];
    self.barView = barView;
    barView.backgroundColor = [UIColor blackColor];
    barView.alpha = 0.8;
    [self.view addSubview:barView];
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(stateBarFrame.size.height + 44);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [backBtn setImage:[UIImage imageNamed:@"navigationbar_icon_back"] forState:(UIControlStateNormal)];
    [barView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(barView.mas_bottom);
        make.left.equalTo(barView);
        make.width.height.mas_equalTo(40);
    }];
    [backBtn addTarget:self action:@selector(dissMiss) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [barView addSubview:self.selectBtn];
    [self.selectBtn setImage:[UIImage imageNamed:@"common_select"] forState:(UIControlStateSelected)];
    [self.selectBtn setImage:[UIImage imageNamed:@"common_unselect"] forState:(UIControlStateNormal)];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(barView.mas_bottom);
        make.right.equalTo(barView.mas_right);
        make.width.height.mas_equalTo(40);
    }];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.numberL = [[UILabel alloc] init];
    [barView addSubview:self.numberL];
    self.numberL.textColor = [UIColor whiteColor];
    [self.numberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(barView);
        make.bottom.equalTo(backBtn.mas_bottom);
    }];
    
    self.numberL.text = [NSString stringWithFormat:@"%ld/%ld",[self.sourceArr indexOfObject:self.photoM] + 1,self.sourceArr.count];
    
    UIButton *nextBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:nextBtn];
    self.nextBtn = nextBtn;
    [nextBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    if (self.selectArr.count > 0) {
        [nextBtn setBackgroundColor:[UIColor orangeColor]];
    }else {
        [nextBtn setBackgroundColor:[UIColor grayColor]];
    }
    [nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    nextBtn.layer.cornerRadius = 15;
    nextBtn.clipsToBounds = YES;
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        } else {
            make.bottom.equalTo(self.view).offset(-20);
        }
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
//    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self.view addSubview:editBtn];
//    self.editBtn = editBtn;
//    [editBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
//    [editBtn setBackgroundColor:[UIColor orangeColor]];
//    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    editBtn.layer.cornerRadius = 15;
//    editBtn.clipsToBounds = YES;
//    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
//        } else {
//            make.bottom.equalTo(self.view).offset(-20);
//        }
//        make.right.equalTo(self.nextBtn.mas_left).offset(-20);
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(60);
//    }];
//    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.countL = [[UILabel alloc] init];
    [barView addSubview:self.countL];
    self.countL.layer.cornerRadius = 10;
    self.countL.backgroundColor = [UIColor blueColor];
    self.countL.textColor = [UIColor whiteColor];
    self.countL.textAlignment = NSTextAlignmentCenter;
    self.countL.font = [UIFont systemFontOfSize:11];
    self.countL.hidden = self.selectArr.count > 0 ? NO:YES;
    self.countL.clipsToBounds = YES;
    [self.countL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectBtn.mas_left).offset(-10);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.selectBtn);
    }];
    self.countL.text = [NSString stringWithFormat:@"%ld",self.selectArr.count];
}

- (void)hiddle {
    self.nextBtn.hidden = !self.nextBtn.hidden;
    self.editBtn.hidden = !self.editBtn.hidden;
    self.collectionView.backgroundColor = self.nextBtn.hidden == YES ? [UIColor blackColor] : [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
 
    if (self.nextBtn.hidden) {
        
        [UIView animateWithDuration:0.23 animations:^{
            [self.barView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(- (stateBarFrame.size.height + 64));
            }];
            self.collectionView.backgroundColor = self.nextBtn.hidden == YES ? [UIColor blackColor] : [UIColor whiteColor];
            [self.view layoutIfNeeded];
        }];
    }else {
        [UIView animateWithDuration:0.23 animations:^{
            [self.barView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
            }];
            self.collectionView.backgroundColor = self.nextBtn.hidden == YES ? [UIColor blackColor] : [UIColor whiteColor];
            [self.view layoutIfNeeded];
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.sourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == DFPreviewViewTypePhoto) {
        DFPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPreviewCell" forIndexPath:indexPath];
        cell.photoM = self.sourceArr[indexPath.item];

        __block __weak typeof(self) weakSelf = self;
        cell.singleTap = ^{
            [weakSelf hiddle];
        };
        
        return cell;
    }else if (self.type == DFPreviewViewTypeVideo) {
         DFVideoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DFVideoPreviewCell" forIndexPath:indexPath];
        cell.videoM = self.sourceArr[indexPath.item];
        __block __weak typeof(self) weakSelf = self;
        cell.singleTap = ^{
            [weakSelf hiddle];
        };
        return cell;
    }else {
        return nil;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.nextBtn.hidden == YES) {
//        [self hiddle];
//    }
    if (self.type == DFPreviewViewTypePhoto) {
        [(DFPhotoPreviewCell *)cell stopEven];
    }else {
        [(DFVideoPreviewCell *)cell displayImg];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == DFPreviewViewTypePhoto) {
        [(DFPhotoPreviewCell *)cell resetScale];
    }else {
        [(DFVideoPreviewCell *)cell displayImg];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentIndex = self.collectionView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    self.selectBtn.selected = NO;
    
    if ([self.selectArr containsObject:self.sourceArr[self.currentIndex]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectBtn.selected = YES;
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectBtn.selected = NO;
        });
    }
    self.numberL.text = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex + 1,self.sourceArr.count];
//    DFPhotoPreviewCell *cell = (DFPhotoPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    

}

- (void)dissMiss {
    if ([self.delegate respondsToSelector:@selector(changeSelectPhoto:andSelectedType:andType:)]) {
        [self.delegate changeSelectPhoto:self.selectArr andSelectedType:self.selectedType andType:self.type];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectBtnClick {
    NSLog(@"--%ld",self.currentIndex);
    if ((self.selectedType == DFPreviewViewTypePhoto && self.type == DFPreviewViewTypeVideo) || (self.selectedType == DFPreviewViewTypeVideo && self.type == DFPreviewViewTypePhoto)) {
        [self alertWithStr:@"照片视频不能同时选择"];
        return;
    }
    
    if (!self.selectBtn.selected) {
        if (self.selectArr.count + 1 > self.maxPhotoCount) {
            [self alertWithStr:[NSString stringWithFormat:@"最多选择%ld%@",self.maxPhotoCount,self.type == DFPreviewViewTypePhoto ? @"张照片":@"个视频"]];
        }else {
            self.selectBtn.selected = !self.selectBtn.selected;
            [self.selectArr addObject:self.sourceArr[self.currentIndex]];
        }
    }else {
        self.selectBtn.selected = !self.selectBtn.selected;
        [self.selectArr removeObject:self.sourceArr[self.currentIndex]];
    }
    self.countL.text = [NSString stringWithFormat:@"%ld",self.selectArr.count];
    self.countL.hidden = self.selectArr.count > 0 ? NO:YES;
    if (self.selectArr.count > 0) {
        [self.nextBtn setBackgroundColor:[UIColor orangeColor]];
    }else {
        [self.nextBtn setBackgroundColor:[UIColor grayColor]];
    }
}

- (void)alertWithStr:(NSString *)str {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)nextBtnClick {
    NSLog(@"%@", [NSString stringWithFormat:@"selectPhotoCount = %ld",self.selectArr.count]);
    [DFPhotoKitDeal writeSelectModelListToTempPathWithList:self.selectArr  type:DFPhotoSizeTypeScaleScreen scale:0.8 success:^(NSArray<NSURL *> *allURL, NSArray<NSURL *> *photoURL, NSArray<NSURL *> *videoURL) {
        
        
        NSLog(@"%@",allURL);
        NSLog(@"%@",[NSTemporaryDirectory() stringByAppendingPathComponent:@""]);
        
        
    } failed:^{
        
    }];
}

//- (void)editBtnClick {
//    NSLog(@"-=-=-=");
//}
@end
