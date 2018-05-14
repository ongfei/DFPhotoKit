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

#import "DFPhotoPreviewViewController.h"

@interface DFPhotoSigleAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) DFPhotoKitManager *photoManager;

@property (nonatomic, strong) NSArray *sourceArr;

@end

@implementation DFPhotoSigleAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 25) / 4, ([UIScreen mainScreen].bounds.size.width - 25) / 4);
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.89 alpha:1];
    
    [self.collectionView registerClass:[DFPhotoSigleCollectionCell class] forCellWithReuseIdentifier:@"PhotoSigleCollectionCell"];
    
    self.photoManager = [DFPhotoKitManager new];
    [self.photoManager getPhotoListWithAlbumModel:self.album complete:^(NSArray *allList, NSArray *photoList, NSArray *videoList) {
        
        self.sourceArr = allList;
        [self.collectionView reloadData];
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.sourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DFPhotoSigleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoSigleCollectionCell" forIndexPath:indexPath];
    
    DFPhotoModel *model = self.sourceArr[indexPath.item];
//    cell.backgroundColor = [UIColor redColor];
    NSLog(@"%@",model);
    
    cell.photoM = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DFPhotoPreviewViewController *preview = [DFPhotoPreviewViewController new];
    preview.sourceArr = self.sourceArr;
    preview.photoM = self.sourceArr[indexPath.item];
    [self.navigationController pushViewController:preview animated:YES];
}

@end


@implementation DFPhotoSigleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageV = [[UIImageView alloc] init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageV setClipsToBounds:YES];
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        self.intrL = [[UILabel alloc] init];
        [self.contentView addSubview:self.intrL];
        self.intrL.font = [UIFont systemFontOfSize:12];
        self.intrL.textAlignment = NSTextAlignmentRight;
        self.intrL.textColor = [UIColor whiteColor];
        [self.intrL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.imageV);
        }];
    }
    
    return self;
}

- (void)setPhotoM:(DFPhotoModel *)photoM {
    _photoM = photoM;
    
    NSString *type;
    switch (photoM.type) {
        case DFPhotoModelMediaTypePhoto:
            type = @"";
            break;
        case DFPhotoModelMediaTypeLivePhoto:
            type = @"LivePhoto";
            break;
        case DFPhotoModelMediaTypePhotoGif:
            type = @"Gif";
            break;
        case DFPhotoModelMediaTypeVideo:
            type = @"Video";
            break;
            
        default:
            break;
    }
    self.intrL.text = type;
    
    [DFPhotoKitDeal getPhotoForPHAsset:photoM.asset size:CGSizeMake((([UIScreen mainScreen].bounds.size.width - 25) / 4)*1.5, (([UIScreen mainScreen].bounds.size.width - 25) / 4)*1.5) completion:^(UIImage *image, NSDictionary *info) {
        self.imageV.image = image;
    }];
    
}

@end
