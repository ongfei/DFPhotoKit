//
//  DFPhotoKitCollectionViewController.m
//  iOS8
//
//  Created by ongfei on 2018/5/4.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPhotoKitCollectionViewController.h"
#import <Masonry.h>
#import "DFPhotoSigleAlbumViewController.h"
#import "DFImageView.h"

@interface DFPhotoKitCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) DFPhotoKitManager *photoManager;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layoutH;
@property (nonatomic, strong) UICollectionViewFlowLayout *layoutV;

@property (nonatomic, assign) BOOL changeState;

@end

@implementation DFPhotoKitCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layoutH];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[PhotoKitCollectionCell class] forCellWithReuseIdentifier:@"PhotoKitCollectionCell"];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    self.photoManager = [DFPhotoKitManager new];
    
    __block __weak typeof(self) weakSelf = self;
    [self.photoManager requestAuthorization:^(BOOL isAuthorization) {
        if (isAuthorization) {
            __strong typeof(self) strongSelf = weakSelf;
            [weakSelf.photoManager getAllPhotoAlbums:^(NSArray *albums) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.collectionView reloadData];

                });
                
            }];
        }
    }];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"转" style:(UIBarButtonItemStylePlain) target:self action:@selector(changeUI)];
    
    
}

- (void)changeUI {
    if (!self.changeState) {
        [self.collectionView setCollectionViewLayout:self.layoutV animated:YES];
    }else {
        [self.collectionView setCollectionViewLayout:self.layoutH animated:YES];
    }
    [self.view layoutIfNeeded];
    self.changeState = !self.changeState;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoManager.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoKitCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoKitCollectionCell" forIndexPath:indexPath];

    cell.albumModel = self.photoManager.albums[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DFPhotoSigleAlbumViewController *photoSigleAlbum = [DFPhotoSigleAlbumViewController new];
    photoSigleAlbum.album = self.photoManager.albums[indexPath.item];
    [self.navigationController pushViewController:photoSigleAlbum animated:YES];
}


- (UICollectionViewFlowLayout *)layoutH {
    if (!_layoutH) {
        _layoutH = [[UICollectionViewFlowLayout alloc] init];
        _layoutH.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 45) / 2.0, ([UIScreen mainScreen].bounds.size.width + 30) / 2.0);
        _layoutH.minimumLineSpacing = 0.0;
        _layoutH.minimumInteritemSpacing = 0.0;
        _layoutH.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _layoutH;
}

- (UICollectionViewFlowLayout *)layoutV {
    if (!_layoutV) {
        _layoutV = [[UICollectionViewFlowLayout alloc] init];
        _layoutV.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width), 80);
        _layoutV.minimumLineSpacing = 1.0;
        _layoutV.minimumInteritemSpacing = 0.0;
        _layoutV.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _layoutV;
}

@end


#pragma mark -  ----------collectionView----------

@interface PhotoKitCollectionCell ()

@property (nonatomic, strong) DFImageView *imageV;

@property (nonatomic, strong) UILabel *albumName;

@property (nonatomic, strong) UILabel *count;

@property (nonatomic, assign) BOOL changeState;

@end

@implementation PhotoKitCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareLayout];
    }
    
    return self;
}

- (void)prepareLayout {
    
    self.imageV = [DFImageView new];
    [self.contentView addSubview:self.imageV];
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.clipsToBounds = YES;
    
    self.albumName = [UILabel new];
    [self.contentView addSubview:self.albumName];
    self.albumName.font = [UIFont systemFontOfSize:13];

    self.count = [UILabel new];
    [self.contentView addSubview:self.count];
    self.count.font = [UIFont systemFontOfSize:12];
    
    [self addConstraintsH];
}

- (void)addConstraintsH {
    [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageV.mas_width);
    }];
    
    [self.albumName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imageV);
        make.top.equalTo(self.imageV.mas_bottom);
        make.height.mas_equalTo(15);
    }];
    
    [self.count mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imageV);
        make.top.equalTo(self.albumName.mas_bottom);
        make.height.mas_equalTo(15);
    }];
}

- (void)addConstraintsV {

    [self.imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(self.imageV.mas_height);
    }];
    
    [self.albumName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(5);
        make.top.equalTo(self.imageV.mas_top).offset(5);
    }];
    
    [self.count mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.albumName);
        make.bottom.equalTo(self.imageV.mas_bottom).offset(-5);
    }];
}

- (void)setAlbumModel:(DFPhotoAlbumModel *)albumModel {
    _albumModel = albumModel;
    if (!albumModel.asset) {
        albumModel.asset = albumModel.result.lastObject;
    }
    __weak typeof(self) weakSelf = self;
    
    CGSize size = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 45), ([UIScreen mainScreen].bounds.size.width - 45));
    
    [DFPhotoKitDeal getImageWithAlbumModel:albumModel size:size completion:^(UIImage *image, DFPhotoAlbumModel *model) {
        if (weakSelf.albumModel == albumModel) {
            weakSelf.imageV.image = image;
        }
    }];
    
    self.albumName.text = albumModel.albumNameCh;
    self.count.text = @(albumModel.result.count).stringValue;
}


- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    if (!self.changeState) {
        [self addConstraintsV];
    }else {
        [self addConstraintsH];
    }
    [self layoutIfNeeded];
    self.changeState = !self.changeState;
}
@end
