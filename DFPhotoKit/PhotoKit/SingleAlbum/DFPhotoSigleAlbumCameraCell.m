//
//  DFPhotoSigleAlbumCameraCell.m
//  iOS8
//
//  Created by ongfei on 2018/6/4.
//  Copyright © 2018年 ongfei. All rights reserved.
//

#import "DFPhotoSigleAlbumCameraCell.h"

@interface DFPhotoSigleAlbumCameraCell ()

@property (nonatomic, strong) UIButton *cameraBtn;
@end
@implementation DFPhotoSigleAlbumCameraCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareLayout];
    }
    return self;
}

- (void)prepareLayout {
#if !TARGET_IPHONE_SIMULATOR
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    previewLayer.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.contentView.layer insertSublayer:previewLayer atIndex:0];
#endif
    
    self.cameraBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.cameraBtn];
    self.cameraBtn.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [self.cameraBtn setImage:[UIImage imageNamed:@"compose_photo_photograph_highlighted"] forState:(UIControlStateNormal)];
    [self.cameraBtn addTarget:self action:@selector(cameraClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)cameraClick {
    if (self.cameraBtnClick) {
        self.cameraBtnClick();
    }
}


- (AVCaptureSession *)session {
    if (!_session) {
        NSError *err;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&err];
        AVCaptureSession *session = [[AVCaptureSession alloc]init];
        _session = session;
        if ([_session canAddInput:input]) {
            [_session addInput:input];
        }
    }
    return _session;
}

- (void)dealloc {
    [self.session stopRunning];
}

@end
