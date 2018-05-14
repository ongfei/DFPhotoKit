//
//  DFPhotoPreviewViewController.m
//  iOS8
//
//  Created by ongfei on 2018/5/9.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPhotoPreviewViewController.h"
#import <Masonry.h>
#import "DFPhotoKitDeal.h"
#import "DFPhotoPreviewCell.h"

@interface DFPhotoPreviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DFPhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
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
    
//    [self.collectionView setContentOffset:CGPointMake(0, 0)];
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    NSInteger index = [self.sourceArr indexOfObject:self.photoM];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:(UICollectionViewScrollPositionNone) animated:NO];
}

- (void)hiddle {
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
    self.collectionView.backgroundColor = self.navigationController.navigationBar.hidden == YES ? [UIColor blackColor] : [UIColor whiteColor];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBar.hidden;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.sourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DFPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPreviewCell" forIndexPath:indexPath];
    cell.photoM = self.sourceArr[indexPath.item];
    
    __block __weak typeof(self) weakSelf = self;
    cell.singleTap = ^{
        [weakSelf hiddle];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(DFPhotoPreviewCell *)cell stopEven];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(DFPhotoPreviewCell *)cell resetScale];
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
//}

@end
